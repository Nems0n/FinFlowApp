//
//  FFKeychainManager.swift
//  FinFlow
//
//  Created by Vlad Todorov on 30.03.23.
//

import Foundation
import Security

enum KeychainService: String {
    case tokenJWT = "jwt-token"
}

enum KeychainAccount: String {
    case finFlow = "FinFlow"
}

final class FFKeychainManager {
    static let shared = FFKeychainManager()
    
    
    private func save(_ data: Data, service: String, account: String) {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
                // Item already exist, thus update it.
                let query = [
                    kSecAttrService: service,
                    kSecAttrAccount: account,
                    kSecClass: kSecClassGenericPassword,
                ] as CFDictionary

                let attributesToUpdate = [kSecValueData: data] as CFDictionary

                // Update existing item
                SecItemUpdate(query, attributesToUpdate)
            
                print("updated")
            }
    }
    
    private func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    public func save<T>(_ item: T, service: KeychainService, account: KeychainAccount) where T : Codable {
        
        do {
            // Encode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            save(data, service: service.rawValue, account: account.rawValue)
            
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    public func read<T>(service: KeychainService, account: KeychainAccount, type: T.Type) -> T? where T : Codable {
        
        // Read item data from keychain
        guard let data = read(service: service.rawValue, account: account.rawValue) else {
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(T.self, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
}
