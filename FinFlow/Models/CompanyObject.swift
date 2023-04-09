//
//  CompanyObject.swift
//  FinFlow
//
//  Created by Vlad Todorov on 8.04.23.
//

import Foundation
import RealmSwift

class CompanyObject: Object {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var dateOfCreation: List<Int>
    @Persisted var inviteLink: String
    @Persisted var revenues: List<String?>
    @Persisted var users: List<UserObject>
    @Persisted var products: List<ProductObject>
}
