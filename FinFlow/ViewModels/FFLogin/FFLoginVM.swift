//
//  FFLoginVM.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.03.23.
//

import Foundation

final class FFLoginVM: NSObject {
    //MARK: - Variables
    var coordinator: AppCoordinator?
    
    var email: String?
    var password: String?
    
    var isActivityIndicator: Binder<Bool?> = Binder(nil)
    var isRequestFailed: Binder<Bool> = Binder(false)
    var isConnectionLost: Binder<Bool> = Binder(false)
    
    //MARK: - Injection
    public func setCoordinator(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - Methods
    public func loginButtonAction() async {
        isActivityIndicator.value = true
        let loginBody = AuthRequestBody(email: email, password: password, username: nil, phone: nil)
        let request = FFRequest(endpoint: .login, httpMethod: .post, httpBody: loginBody)
        do {
            guard let token = try await FFService.shared.execute(request, expecting: TokenJWT.self) else { return }
            FFKeychainManager.shared.save(token, service: .tokenJWT, account: .finFlow)
            await self.coordinator?.trigger(.main)
        } catch(let error) {
            if error.localizedDescription.contains("The request timed out.") {
                self.isConnectionLost.value = true
            }
        }
    }
    
}
