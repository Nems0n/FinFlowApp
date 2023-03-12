//
//  FFStorageMainViewModel.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import Foundation
import UIKit


final class FFStorageVM: NSObject {
    //MARK: - Variables
    public var userAvatarAction = UIAction { _ in
        print("button touched")
    }

    var buttonHasPressed: Binder<Bool> = Binder(false)
    var isDataReloaded: Binder<Bool> = Binder(false)
    
    var priceSortButtonPressed: Binder<Bool> = Binder(false)
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
    
    var dataSource: [Product] = {
        var array = [Product]()
        let product1 = Product(id: 235, productName: "Bread Borodinsky", price: 45.0, amount: 5)
        let product2 = Product(id: 2564, productName: "Cottage Cheese Premia", price: 120.0, amount: 25)
        array.append(product1)
        array.append(product2)
        return array
    }()
    
    //MARK: - Methods
    func mapCellData() {
        self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
    
    func priceTouch() {
        self.priceSortButtonPressed.value = true
        print("pressed avatar")
    }
    
    func addNewProduct() {
        let newProduct = Product(id: 2345, productName: "Super Mega Greenish Red Apple Pro Bundle From My Heart", price: 235, amount: 2345)
        self.dataSource.append(newProduct)
        self.isDataReloaded = Binder(true)
        mapCellData()
    }
}

