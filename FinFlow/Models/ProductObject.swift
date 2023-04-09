//
//  ProductObject.swift
//  FinFlow
//
//  Created by Vlad Todorov on 8.04.23.
//

import Foundation
import RealmSwift

class ProductObject: Object {
    @Persisted var id: Int
    @Persisted var productName: String
    @Persisted var price: Float
    @Persisted var amount: Int
    @Persisted var category: String
    @Persisted var supplier: String?
}
