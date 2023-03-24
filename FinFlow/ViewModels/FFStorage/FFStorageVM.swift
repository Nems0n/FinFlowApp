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
    
    var priceSortButtonPressed: Binder<Bool> = Binder(false)
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
    
    var dataSource: [Product] = {
        var array = [Product]()
        let product1 = Product(id: 235, productName: "Bread Borodinsky", price: 45.0, amount: 5, category: .cereal, supplier: "METRO")
        let product2 = Product(id: 2564, productName: "Cottage Cheese Premia", price: 120.0, amount: 25, category: .cereal, supplier: "METRO")
        array.append(product1)
        array.append(product2)
        return array
    }()
    
    //MARK: - Injection
    
    public func setCoordinator(coordinator: FFStorageCoordinator) {
        self.coordinator = coordinator
    }
    
    
    //MARK: - Methods
    public func mapCellData() {
        self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
    
    public func priceTouch() {
        self.cellDataSource.value = self.cellDataSource.value.reversed()

        print("pressed price from StorageVM")
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
}

