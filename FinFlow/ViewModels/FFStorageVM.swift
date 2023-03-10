//
//  FFStorageMainViewModel.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import Foundation
import UIKit

final class FFStorageVM: NSObject {
    public var userAvatarAction = UIAction { _ in
        print("button touched")
    }
    
    var buttonHasPressed: Binder<Bool> = Binder(false)
    var isDataReloaded: Binder<Bool> = Binder(false)
    
//    var priceSortButtonPressed: Binder<Bool> = Binder(false)
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
//    var cellDataSource: [FFProductCellVM?] = []
    
    var dataSource: [Product] = {
        var array = [Product]()
        let product1 = Product(id: 235, productName: "Bread", price: 2.0, amount: 5, backgroundColor: .blue.withAlphaComponent(0.2))
        let product2 = Product(id: 2564, productName: "Apple", price: 1.8, amount: 25, backgroundColor: .green.withAlphaComponent(0.2))
        array.append(product1)
        array.append(product2)
        return array
    }()
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
    
     func userAvatarTouched() {
         self.buttonHasPressed = Binder(true)
    }
    
    func addNewProduct() {
        let newProduct = Product(id: 2345, productName: "34256", price: 235, amount: 2345, backgroundColor: .black.withAlphaComponent(0.15))
        self.dataSource.append(newProduct)
        print("action in vm")
        self.isDataReloaded = Binder(true)
        print(self.isDataReloaded.value)
//        self.dataSource = self.dataSource.reversed()
        mapCellData()
    }
}

