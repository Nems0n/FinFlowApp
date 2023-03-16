//
//  Product.swift
//  FinFlow
//
//  Created by Vlad Todorov on 7.03.23.
//

import Foundation
import UIKit

struct Product {
    let id: Int
    let productName: String
    let price: Float
    let amount: Int
    let category: Category
    let supplier: String?
//    let discount: Class?
}


enum Category {
    case dairy
    case fruit
    case vegetables
    case cereal
    case meat
    case fish
    case grains
    case sweet
    case water
    case snack
}
