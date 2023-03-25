//
//  FFRequest.swift
//  FinFlow
//
//  Created by Vlad Todorov on 25.03.23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

final class FFRequest {
     
    private struct Constants {
        static let baseUrl = "https://test-back-ncm8.onrender.com"
    }
    
    private let endpoint: FFEndpoint
    
    private var UrlString: String {
        var string = Constants.baseUrl
        string += endpoint.rawValue
        return string
    }
    
    private let httpMethod: HTTPMethod
    
    public var url: URL? {
        return URL(string: UrlString)
    }
    
    public init(endpoint: FFEndpoint, httpMethod: HTTPMethod) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
    }
    
}
