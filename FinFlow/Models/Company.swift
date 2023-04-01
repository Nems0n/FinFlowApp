//
//  Company.swift
//  FinFlow
//
//  Created by Vlad Todorov on 31.03.23.
//

import Foundation

struct Company: Codable {
    let id: Int
    let name: String
    let dateOfCreation: [Int]
    let inviteLink: String
    let revenues: [String?]
    let users: [User]
    let products: [Product]
}
