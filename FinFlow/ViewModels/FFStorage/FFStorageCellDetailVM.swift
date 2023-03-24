//
//  FFStorageCellDetailVM.swift
//  FinFlow
//
//  Created by Vlad Todorov on 24.03.23.
//

import Foundation
import UIKit

class FFStorageCellDetailVM: NSObject {
    
    var coordinator: FFStorageCoordinator?
    
    var id: Int
    var name: String
    var price: Float
    var amount: Int
    var category: Category
    var supplier: String?
    
    init(product: Product) {
        self.id = product.id
        self.name = product.productName
        self.price = product.price
        self.amount = product.amount
        self.category = product.category
        self.supplier = product.supplier
    }
    
    public func backButtonDidTap() {
        coordinator?.trigger(.pop)
    }
}
