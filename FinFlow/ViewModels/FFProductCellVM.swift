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
    var backgroundColor: UIColor
    
    init(product: Product) {
        self.id = product.id
        self.backgroundColor = product.backgroundColor
    }
}
