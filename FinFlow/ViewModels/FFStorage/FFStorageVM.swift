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

    var buttonHasPressed: Binder<Bool> = Binder(false)
    var isDataReloaded: Binder<Bool> = Binder(false)
    var isConnectionFailed: Binder<Bool?> = Binder(nil)
    
    var priceSortButtonPressed: Binder<Bool> = Binder(false)
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
    
    private var isPriceDescending: Bool = false
    
    var dataSource = [Product]() {
        didSet {
            mapCellData()
        }
    }
    
    var realmDataSource = [Product]()
    
    
    //MARK: - Init
    override init() {
        super.init()
    
        DispatchQueue.main.async { [weak self] in
            let companyObject = FFRealmManager.shared.fetch(CompanyObject.self)
            guard let productObjects = companyObject?.products else { return }
            self?.dataSource = productObjects.map { DataMapper.mapToProduct($0) }
        }
        Task {
            await getProductsArray()
            
        }
        notificationToken = FFRealmManager.shared.realm.observe({ [weak self] notification, realm in
            guard let self = self else { return }
            
            let companyObject = FFRealmManager.shared.fetch(CompanyObject.self)
            guard let productObjects = companyObject?.products else { return }
            realmDataSource = productObjects.map { DataMapper.mapToProduct($0) }
            dataSource = realmDataSource
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
//        if dataSource.isEmpty {
//           let companyObject = FFRealmManager.shared.fetch(CompanyObject.self)
//           guard let productObjects = companyObject?.products else { return }
//           dataSource = productObjects.map { DataMapper.mapToProduct($0) }
//       }
       self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
    
    public func bestSellerDidTap() {
        print("tapped")
    }
    
    public func sortByPrice() {
        dataSource.sort(by: { isPriceDescending ? $0.price < $1.price : $0.price > $1.price})
        isPriceDescending.toggle()
    }
    
    public func addNewProduct() {
        print("added")
    }
    
    public func cellDidTap(with viewModel: AnyObject) {
        coordinator?.trigger(.detail(viewModel))
        
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
    
    //MARK: - Private Methods
    
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
//            DispatchQueue.main.async { [weak self] in
//                let companyObject = FFRealmManager.shared.fetch(CompanyObject.self)
//                guard let productObjects = companyObject?.products else { return }
//                self?.dataSource = productObjects.map { DataMapper.mapToProduct($0) }
//            }
            
        }
    }
}

