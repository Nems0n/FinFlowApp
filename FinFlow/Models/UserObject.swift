//
//  UserObject.swift
//  FinFlow
//
//  Created by Vlad Todorov on 8.04.23.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name = String()
    @Persisted var allows: List<String>
    @Persisted var companyId: Int?
    @Persisted var dateOfCreation: List<Int>
    @Persisted var email: String
    @Persisted var role: String
    @Persisted var phoneNumber: String?
    @Persisted var photos: String?
    @Persisted var company: Int
}
