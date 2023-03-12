//
//  FFProductCellVM.swift
//  FinFlow
//
//  Created by Vlad Todorov on 7.03.23.
//

import Foundation
import UIKit

class FFProductCellVM {
    
    var id: Int
    var name: String
    var price: Float
    
    init(product: Product) {
        self.id = product.id
        self.name = product.productName
        self.price = product.price
    }
}
