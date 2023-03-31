//
//  Token.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.03.23.
//

import Foundation

struct TokenJWT: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
