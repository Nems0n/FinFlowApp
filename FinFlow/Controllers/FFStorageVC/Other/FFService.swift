//
//  FFService.swift
//  FinFlow
//
//  Created by Vlad Todorov on 25.03.23.
//

import Foundation

final class FFService {
    static let shared = FFService()
    
    public init() {}
    
    public func execute<T: Codable>(_ request: FFRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        
    }
    
}
