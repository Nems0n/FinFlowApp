//
//  FFStorageMainViewModel.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import Foundation

final class FFStorageVM: NSObject {
    //MARK: - Variables
    
    var coordinator: FFStorageCoordinator?

    var buttonHasPressed: Binder<Bool> = Binder(false)
    var isDataReloaded: Binder<Bool> = Binder(false)
    var isConnectionFailed: Binder<Bool?> = Binder(nil)
    
    var priceSortButtonPressed: Binder<Bool> = Binder(false)
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
    
    private var isPriceDescending: Bool = false
    
    var dataSource: [Product] = {
        var array = [Product]()
        
        return array
    }() {
        didSet {
            mapCellData()
        }
    }
    
    
    //MARK: - Init
    override init() {
        super.init()
        Task {
            await getProductsArray()
        }
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
    }
    
    public func sortByPrice() {
        dataSource.sort(by: { isPriceDescending ? $0.price < $1.price : $0.price > $1.price})
        isPriceDescending.toggle()
    }
    
    public func addNewProduct() {
        let newProduct = Product(id: 2345, productName: "Super Mega Greenish Red Apple Pro Bundle From My Heart", price: 235, amount: 2345, category: .cereal, supplier: "METRO")
        self.dataSource.append(newProduct)
        self.isDataReloaded = Binder(true)
    }
    
    public func cellDidTap(with viewModel: AnyObject) {
        coordinator?.trigger(.detail(viewModel))
        
    }
    
    //MARK: - Private Methods
    
//    public func getProductsArray() async {
//        let request = FFRequest(endpoint: .getData, httpMethod: .get, httpBody: nil)
//        do {
//            let company = try await FFService.shared.execute(request, expecting: Company.self)
//            guard let productsArray = company?.products else { return }
//            self.dataSource = productsArray
//            self.mapCellData()
//            self.isDataReloaded.value = true
//        } catch(let error) {
//            let loginError = error as? FFService.FFServiceError
//            if loginError == FFService.FFServiceError.loginRequired {
//                self.coordinator?.output?.goToLogin()
//            }
//            self.isConnectionFailed.value = true
//            print(error)
//        }
//    }
    
    public func getProductsArray() async {
        let request = FFRequest(endpoint: .getData, httpMethod: .get, httpBody: nil)
        do {
            let company = try await FFService.shared.execute(request, expecting: Company.self)
            guard let productsArray = company?.products else { return }
            self.dataSource = productsArray
            self.mapCellData()
            self.isDataReloaded.value = true
        } catch(let error) {
            let loginError = error as? FFService.FFServiceError
            if loginError == FFService.FFServiceError.loginRequired {
                self.coordinator?.output?.goToLogin()
            }
            self.isConnectionFailed.value = true
            self.isDataReloaded.value = true
            print(error)
        }
    }
}

