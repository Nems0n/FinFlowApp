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
        case wrongExpectedType
        case loginRequired
        case defaultError
    }
    
    enum FFServiceAuthType {
        case bearer
        case refresh
    }
    
    //MARK: - Send API Call
//    public func execute<T: Codable>(_ request: FFRequest, expecting type: T.Type?, authorization: FFServiceAuthType = .bearer, completion: @escaping (Result<T, Error>) -> Void) {
//
//        guard let urlRequest = self.request(from: request, authType: authorization) else {
//            completion(.failure(FFServiceError.failedToCreateRequest ))
//            return
//        }
//        // Config for URLSession
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 5
//        let session = URLSession(configuration: sessionConfig)
//
//        //MARK: - "GET" Request
//        if urlRequest.httpMethod == HTTPMethod.get.rawValue {
//            let task = session.dataTask(with: urlRequest) { data, response, error in
//
//                let response = response as? HTTPURLResponse
//                var getRequestError = error
//
//                if response?.statusCode == 423 {
//
//                    let token = FFKeychainManager.shared.read(service: .tokenJWT, account: .finFlow, type: TokenJWT.self)
//                    let request = FFRequest(endpoint: .refreshToken, httpMethod: .post, httpBody: token?.refreshToken)
//                    FFService.shared.execute(request, expecting: TokenJWT.self, authorization: .refresh) { result in
//                        switch result {
//                        case .success(let token):
//                            FFKeychainManager.shared.save(token, service: .tokenJWT, account: .finFlow)
//                        case .failure(_): getRequestError = FFServiceError.loginRequired
//
//                        }
//                    }
//                }
//
//                guard let data = data, error == nil else {
//                    completion(.failure(getRequestError ?? FFServiceError.failedToGetData))
//                    return
//                }
//
//
//                // Decode response
//                do {
//                    guard let type = type.self else { return }
//                    let result = try JSONDecoder().decode(type, from: data)
//                    completion(.success(result))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
//        
//        //MARK: - "POST" Request
//        if urlRequest.httpMethod == HTTPMethod.post.rawValue && type.self != nil {
//            let task = session.dataTask(with: urlRequest) { data, response, error in
//                let response = response as? HTTPURLResponse
//                var getRequestError = error
//                if response?.statusCode == 423 {
//
//                    let token = FFKeychainManager.shared.read(service: .tokenJWT, account: .finFlow, type: TokenJWT.self)
//                    let request = FFRequest(endpoint: .refreshToken, httpMethod: .post, httpBody: token?.refreshToken)
//                    FFService.shared.execute(request, expecting: TokenJWT.self, authorization: .refresh) { result in
//                        switch result {
//                        case .success(let token):
//                            FFKeychainManager.shared.save(token, service: .tokenJWT, account: .finFlow)
//                        case .failure(_): getRequestError = FFServiceError.loginRequired
//                        }
//                    }
//                }
//
//                guard let data = data, error == nil else {
//                    completion(.failure(getRequestError ?? FFServiceError.failedToPostData))
//                    return
//                }
//                // Decode response
//
//
//                do {
//                    let result = try JSONDecoder().decode(type.self!, from: data)
//                    completion(.success(result))
//                } catch {
//                    completion(.failure(error))
//                }
//            }
//            task.resume()
//        }
//    }
    
    //MARK: - Private
    private func request(from ffRequest: FFRequest, authType: FFServiceAuthType) -> URLRequest? {
        guard let url = ffRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = ffRequest.httpMethod
        request.httpBody = ffRequest.httpBody
        let tokenJWT = FFKeychainManager.shared.read(service: .tokenJWT, account: .finFlow, type: TokenJWT.self)
        switch authType {
        case .bearer:
            if let accessToken = tokenJWT?.accessToken {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        case .refresh:
            if let refreshToken = tokenJWT?.refreshToken {
                request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
            }
        }
        return request
    }
    
    
    
    
    public func execute<T: Codable>(_ request: FFRequest, expecting type: T.Type?, authorization: FFServiceAuthType = .bearer) async throws -> T? {
        guard let urlRequest = self.request(from: request, authType: authorization) else {
            throw FFServiceError.failedToCreateRequest
        }
        /// Config for URLSession
        let sesseionConfig = URLSessionConfiguration.default
        sesseionConfig.timeoutIntervalForRequest = 5
        let session = URLSession(configuration: sesseionConfig)
        
        //MARK: - Making Request
        switch urlRequest.httpMethod {
            ///"GET" Request
        case HTTPMethod.get.rawValue:
            let (data, response) = try await session.data(for: urlRequest)
            /// statusCode 423: JWT Token is expired
            if (response as? HTTPURLResponse)?.statusCode == 423 {
                let token = FFKeychainManager.shared.read(service: .tokenJWT, account: .finFlow, type: TokenJWT.self)
                let request = FFRequest(endpoint: .refreshToken, httpMethod: .post, httpBody: token?.refreshToken)
                do {
                    let token = try await FFService.shared.execute(request, expecting: TokenJWT.self, authorization: .refresh)
                    guard token != nil else {
                        throw FFServiceError.loginRequired
                    }
                    FFKeychainManager.shared.save(token, service: .tokenJWT, account: .finFlow)
                } catch {
                    throw FFServiceError.loginRequired
                }
            }
            
            guard let type = type.self else {
                throw FFServiceError.wrongExpectedType
            }
            guard let result = try? JSONDecoder().decode(type, from: data) else {
                throw FFServiceError.failedToGetData
            }
            return result
            
            ///"POST" Method
        case HTTPMethod.post.rawValue:
            let (data, response) = try await session.data(for: urlRequest)
            /// statusCode 423: JWT Token is expired
            if (response as? HTTPURLResponse)?.statusCode == 423 {
                let token = FFKeychainManager.shared.read(service: .tokenJWT, account: .finFlow, type: TokenJWT.self)
                let request = FFRequest(endpoint: .refreshToken, httpMethod: .post, httpBody: token?.refreshToken)
                do {
                    let token = try await FFService.shared.execute(request, expecting: TokenJWT.self, authorization: .refresh)
                    guard token != nil else {
                        throw FFServiceError.loginRequired
                    }
                    FFKeychainManager.shared.save(token, service: .tokenJWT, account: .finFlow)
                } catch {
                    throw FFServiceError.loginRequired
                }
            }
            guard let type = type else {
                return nil
            }
            guard let result = try? JSONDecoder().decode(type, from: data) else {
                throw FFServiceError.failedToGetData
            }
            return result
             
        default: throw FFServiceError.defaultError
        }
    }
}
