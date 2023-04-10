//
//  ProductObject.swift
//  FinFlow
//
//  Created by Vlad Todorov on 8.04.23.
//

import Foundation
import RealmSwift

class ProductObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var productName: String
    @Persisted var price: Float
    @Persisted var amount: Int
    @Persisted var category: String
    @Persisted var supplier: String?
    @Persisted var discount: DiscountObject?
}

class DiscountObject: Object {
    @Persisted var startDate: List<Int>
    @Persisted var endDate: List<Int>
    @Persisted var discountProperty: Double
}
