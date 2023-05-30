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
    
    public func execute<T/*: Codable*/>(_ request: FFRequest, expecting type: T.Type? = Void.self, authorization: FFServiceAuthType = .bearer) async throws -> T? {
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
            
            guard let type = type.self as? Decodable.Type else {
                throw FFServiceError.wrongExpectedType
            }
            do {
                let result = try JSONDecoder().decode(type, from: data) as? T
                // use result here
                return result
            } catch let error {
                print("Error decoding JSON: \(error)")
                throw FFServiceError.failedToGetData
            }
            
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
            guard let type = type as? Decodable.Type else {
                return nil
            }
            guard let result = try? JSONDecoder().decode(type, from: data) as? T else {
                throw FFServiceError.failedToGetData
            }
            return result
            
            ///"DELETE" Method
        case HTTPMethod.delete.rawValue:
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
            guard let type = type as? Decodable.Type else {
                return nil
            }
            guard let result = try? JSONDecoder().decode(type, from: data) as? T else {
                throw FFServiceError.failedToGetData
            }
            return result
             
        default: throw FFServiceError.defaultError
        }
    }
    
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

}
