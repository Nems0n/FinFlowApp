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
    }()
    
    
    //MARK: - Init
    override init() {
        super.init()
        getProductsArray()
    }
    
    //MARK: - Injection
    
    public func setCoordinator(coordinator: FFStorageCoordinator) {
        self.coordinator = coordinator
    }
    
    
    //MARK: - Methods
    public func mapCellData() {
        self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
    
    public func bestSellerDidTap() {
        print("tapped")
        print(dataSource.count)
    }
    
    public func sortByPrice() {
        dataSource.sort(by: { isPriceDescending ? $0.price < $1.price : $0.price > $1.price})
        isPriceDescending.toggle()
        mapCellData()
    }
    
    public func addNewProduct() {
        let newProduct = Product(id: 2345, productName: "Super Mega Greenish Red Apple Pro Bundle From My Heart", price: 235, amount: 2345, category: .cereal, supplier: "METRO")
        self.dataSource.append(newProduct)
        self.isDataReloaded = Binder(true)
        mapCellData()
    }
    
    public func cellDidTap(with viewModel: AnyObject) {
        coordinator?.trigger(.detail(viewModel))
        
    }
    
    //MARK: - Private Methods
    
    public func getProductsArray() {
        let request = FFRequest(endpoint: .getData, httpMethod: .get, httpBody: nil)
        FFService.shared.execute(request, expecting: Company.self) { [weak self] result in
            switch result {
            case .success(let company):
                guard let self = self else { return }
                let productsArray = company.products
                self.dataSource = productsArray
                self.mapCellData()
                self.isDataReloaded.value = true
            case .failure(let error):
                let loginError = error as? FFService.FFServiceError
                if loginError == FFService.FFServiceError.loginRequired {
                    self?.coordinator?.output?.goToLogin()
                }
                self?.isConnectionFailed.value = true
                print(error)
            }
        }
    }
}

