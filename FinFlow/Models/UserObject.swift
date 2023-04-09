//
//  UserObject.swift
//  FinFlow
//
//  Created by Vlad Todorov on 8.04.23.
//

import Foundation
import RealmSwift

class UserObject: Object {
    @Persisted var id: Int
    @Persisted var allows: List<String>
    @Persisted var companyId: Int?
    @Persisted var dateOfCreation: List<Int>
    @Persisted var email: String
    @Persisted var role: String
    @Persisted var phoneNumber: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
