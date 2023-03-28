//
//  FFRequest.swift
//  FinFlow
//
//  Created by Vlad Todorov on 25.03.23.
//

import Foundation

//MARK: - HTTP Methods for FFRequest
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
    
    public let httpMethod: String
    
    public var url: URL? {
        return URL(string: UrlString)
    }
    
    public var httpBody: Data?
    
    //MARK: - Init
    public init(endpoint: FFEndpoint, httpMethod: HTTPMethod, httpBody: [String: Any]?) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod.rawValue
        
        guard let bodyObject = httpBody else { return }
        let jsonData = try? JSONSerialization.data(withJSONObject: bodyObject)
        self.httpBody = jsonData
    }
    
    
}
