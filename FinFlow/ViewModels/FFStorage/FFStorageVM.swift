//
//  FFStorageMainViewModel.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import Foundation
import RealmSwift

final class FFStorageVM: NSObject {
    //MARK: - Variables
    
    var coordinator: FFStorageCoordinator?
    
    private var notificationToken: NotificationToken?

    var userImageData: Binder<Data?> = Binder(UserDefaults.standard.data(forKey: "userImage"))
    
    var buttonHasPressed: Binder<Bool> = Binder(false)
    var isDataReloaded: Binder<Bool> = Binder(false)
    var isConnectionFailed: Binder<Bool?> = Binder(nil)
    
    var priceSortButtonPressed: Binder<Bool> = Binder(false)
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
    
    
    private var isPriceDescending: Bool = false
    private var isStockDescending: Bool = false
    private var isSupplierDescending: Bool = false
    
    var dataSource = [Product]() {
        didSet {
            mapCellData()
        }
    }
    
    var realmDataSource = [Product]()
    
    var searchDataSource: Binder<[Product]> = Binder([])
    
    
    
    //MARK: - Init
    override init() {
        super.init()
    
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let companyObject = FFRealmManager.shared.fetch(CompanyObject.self)
            guard let productObjects = companyObject?.products else { return }
            self.realmDataSource = productObjects.map { DataMapper.mapToProduct($0) }
            self.dataSource = self.realmDataSource
        }
        Task {
            await getProductsArray()
            await getUser()
            await loadUserImage()
        }
        
        notificationToken = FFRealmManager.shared.realm.observe({ [weak self] notification, realm in
            guard let self = self else { return }
            
            let companyObject = FFRealmManager.shared.fetch(CompanyObject.self)
            guard let productObjects = companyObject?.products else { return }
            self.realmDataSource = productObjects.map { DataMapper.mapToProduct($0) }
            self.dataSource = self.realmDataSource
        })
        
    }
    
    deinit {
           notificationToken?.invalidate()
       }
    
    //MARK: - Injection
    
    public func setCoordinator(coordinator: FFStorageCoordinator) {
        self.coordinator = coordinator
    }
    
    
    //MARK: - Methods
    private func mapCellData() {
       self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
    
    public func bestSellerDidTap() {
        print("tapped")
        print(dataSource.count)
        print(realmDataSource.count)
    }
    
    
    public func addNewProduct() {
        guard let selfCoordinator = coordinator else { return }
        let vm = FFAddProductVM(coordinator: selfCoordinator)
        coordinator?.trigger(.addProduct(vm))
    }
    
    public func cellDidTap(with viewModel: AnyObject) {
        coordinator?.trigger(.detail(viewModel))
    }
    
    public func viewMoreDidTap(with viewModel: AnyObject) {
        coordinator?.trigger(.allGoods(viewModel))
    }
    
    public func popViewController() {
        coordinator?.trigger(.pop)
    }
    
    //MARK: - Sort Methods
    public func sortByPrice() {
        dataSource.sort(by: { isPriceDescending ? $0.price < $1.price : $0.price > $1.price})
        isPriceDescending.toggle()
    }
    
    public func categorySort(with states: [Category]) {
        guard !states.isEmpty else { return dataSource = realmDataSource }
        let matchingCategories = Set(realmDataSource.map {$0.category}).intersection(Set(states))
        if matchingCategories.isEmpty {
                dataSource = []
            } else {
                dataSource = realmDataSource.filter({ matchingCategories.contains($0.category)})
            }
    }
    
    public func sortByStock() {
        dataSource.sort(by: { isStockDescending ? $0.amount < $1.amount : $0.amount > $1.amount})
        isStockDescending.toggle()
    }
    
    public func sortBySupplier() {
        dataSource.sort(by: { first, second in
            guard first.supplier != nil && second.supplier != nil else { return false }
            return isSupplierDescending ? first.supplier! < second.supplier! : first.supplier! > second.supplier!
        })
        isSupplierDescending.toggle()
    }
    
    //MARK: - Public Methods
    
    public func getProductsArray() async {
        let request = FFRequest(endpoint: .getData, httpMethod: .get, httpBody: nil)
        do {
            guard let company = try await FFService.shared.execute(request, expecting: Company.self) else { return }
            let companyObject = DataMapper.mapToCompanyObject(company)
            DispatchQueue.main.async {
                FFRealmManager.shared.add(companyObject)
            }
            self.isDataReloaded.value = true
        } catch(let error) {
            let loginError = error as? FFService.FFServiceError
            if loginError == FFService.FFServiceError.loginRequired {
                self.coordinator?.output?.goToLogin()
            }
            self.isConnectionFailed.value = true
            self.isDataReloaded.value = true
            
        }
    }
    
    public func getUser() async {
        let request = FFRequest(endpoint: .getMe, httpMethod: .get, httpBody: nil)
        
        do {
            guard let user = try await FFService.shared.execute(request, expecting: User.self) else { return }
            let userObject = DataMapper.mapToUserObject(user)
            DispatchQueue.main.async {
                FFRealmManager.shared.add(userObject)
            }
            
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    @MainActor func loadUserImage() async {
        guard let uo = FFRealmManager.shared.fetch(UserObject.self), let photos = (DataMapper.mapToUser(uo)).photos else {
            return
        }
        
        do {
            guard let requestURL = FFRequest(endpoint: .getImage, httpMethod: .get, httpBody: nil).url?.absoluteString,
                  let imageURL = URL(string: requestURL + photos) else { return }
 
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            guard let imageJpegData = UIImage(data: imageData)?.jpegData(compressionQuality: 0.5) else { return }
            UserDefaults.standard.set(imageJpegData, forKey: "userImage")
            userImageData.value = UserDefaults.standard.data(forKey: "userImage")
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    public func updateSearchController(searchBarText: String?) {
//        searchDataSource.value = realmDataSource
        
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { return }
            self.searchDataSource.value = realmDataSource.filter( { $0.productName.lowercased().contains(searchText)})
        }
    }
}

