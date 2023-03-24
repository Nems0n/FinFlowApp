//
//  FFProductCellVM.swift
//  FinFlow
//
//  Created by Vlad Todorov on 7.03.23.
//

import Foundation
import UIKit

class FFProductCellVM {
    
    var product: Product
    
    var id: Int
    var name: String
    var price: Float
    var amount: Int
    var category: Category
    var supplier: String?
    
    init(product: Product) {
        self.product = product
        self.id = product.id
        self.name = product.productName
        self.price = product.price
        self.amount = product.amount
        self.category = product.category
        self.supplier = product.supplier
    }
}
