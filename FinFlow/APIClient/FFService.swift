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
    
    enum FFServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
        case failedToPostData
    }
    
    //MARK: - Send API Call
    public func execute<T: Codable>(_ request: FFRequest, expecting type: T.Type?, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(FFServiceError.failedToCreateRequest ))
            return
        }
        // Config for URLSession
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: sessionConfig)
        
        //MARK: - "GET" Request
        if urlRequest.httpMethod == HTTPMethod.get.rawValue {
            let task = session.dataTask(with: urlRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? FFServiceError.failedToGetData))
                    return
                }
                // Decode response
                do {
                    guard let type = type.self else { return }
                    let result = try JSONDecoder().decode(type, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
        //MARK: - "POST" Request
        if urlRequest.httpMethod == HTTPMethod.post.rawValue && type.self != nil {
            let task = session.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? FFServiceError.failedToPostData))
                    return
                }
                // Decode response
                do {
                    let result = try JSONDecoder().decode(type.self!, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Private
    private func request(from ffRequest: FFRequest) -> URLRequest? {
        guard let url = ffRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = ffRequest.httpMethod
        request.httpBody = ffRequest.httpBody
        return request
    }
}
