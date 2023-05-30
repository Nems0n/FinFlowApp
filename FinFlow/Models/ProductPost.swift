//
//  ProductPost.swift
//  FinFlow
//
//  Created by User Account on 22/05/2023.
//

import Foundation

struct ProductPost: Codable {
    let name: String
    let category: Category
    let price: Float
    let amount: Int
    let supplier: String?
}

struct ProductToDelete: Codable {
    let id: Int
}
