//
//  CompanyObject.swift
//  FinFlow
//
//  Created by Vlad Todorov on 8.04.23.
//

import Foundation
import RealmSwift

class CompanyObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var dateOfCreation: List<Int>
    @Persisted var inviteLink: String
    @Persisted var revenues: List<RevenueObject>
    @Persisted var users: List<UserObject>
    @Persisted var products: List<ProductObject>
}

class RevenueObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var date: List<Int>
    @Persisted var sold: Int
}
