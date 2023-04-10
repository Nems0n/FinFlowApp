//
//  User.swift
//  FinFlow
//
//  Created by Vlad Todorov on 22.02.23.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let allows: [StorageView]
    let companyId: Int?
    let dateOfCreation: [Int]?
    let email: String
    let role: Roles
    let phoneNumber: String?
    let company: Int
    let photos: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case allows
        case companyId = "company_id"
        case dateOfCreation
        case email
        case role
        case phoneNumber = "phone_number"
        case company
        case photos
    }
}

enum StorageView: String, Codable {
    case storageView = "storage_view"
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
    case administrator = "ADMINISTRATOR"
}

/* "storage_view",
 "storage_edit",
 "promo_edit",
 "promo_view",
 "finance_view",
 "finance_edit",
 "admin_edit",
 "admin_view"*/
