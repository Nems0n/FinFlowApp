//
//  AuthRequest.swift
//  FinFlow
//
//  Created by Vlad Todorov on 29.03.23.
//

import Foundation

struct AuthRequest: Codable {
    let email: String?
    let password: String?
    let username: String?
    let phone: String?
}
