//
//  User.swift
//  FinFlow
//
//  Created by Vlad Todorov on 22.02.23.
//

import Foundation

struct User: Codable {
    let id: Int
    let allows: StorageView
    let companyId: Int
    let dateOfCreation: String
    let email: String
    let role: Roles
    let phoneNumber: String
    // чуть позже добавить userImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case allows
        case companyId = "company_id"
        case dateOfCreation
        case email
        case role
        case phoneNumber = "phone_number"
    }
}

enum StorageView: String, Codable {
    case storageEdit = "storage_edit"
    case promoEdit = "promo_edit"
    case promoView = "promo_view"
    case financeView = "finance_view"
    case financeEdit = "finance_edit"
    case adminEdit = "admin_edit"
    case adminView = "admin_view"
}

enum Roles: String, Codable {
    case admin = "ADMIN"
    case owner = "OWNER"
    case user = "USER"
    case checker = "CHECKER"
    case ladder = "LADDER"
}
