//
//  Product.swift
//  FinFlow
//
//  Created by Vlad Todorov on 7.03.23.
//

import Foundation
import UIKit

struct Product: Codable {
    let id: Int
    let productName: String
    let price: Float
    let amount: Int
    let category: Category
    let supplier: String?
//    let discount: Class?
}


enum Category: String, Codable {
    case dairy = "DAIRY"
    case fruit = "FRUIT"
    case vegetables = "VEGETABLES"
    case cereal = "CERAL"
    case meat = "MEAT"
    case fish = "FISH"
    case grains = "GRAINS"
    case sweet = "SWEET"
    case water = "WATER"
    case snack = "SNACK"
}
