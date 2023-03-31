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
    public func loginButtonAction() {
        isActivityIndicator.value = true
        let loginBody = AuthRequestBody(email: email, password: password, username: nil, phone: nil)
        print("request started")
        
        
        let request = FFRequest(endpoint: .login, httpMethod: .post, httpBody: loginBody)
        FFService.shared.execute(request, expecting: TokenJWT.self) { [weak self] result in
            self?.isActivityIndicator.value = false
            switch result {
            case .success(let token):
                
                DispatchQueue.main.async {
                    
//                    print(token)
                    FFKeychainManager.shared.save(token, service: .tokenJWT, account: .finFlow)
                    self?.coordinator?.trigger(.main)
                }
            case .failure(let error):
                let description = error.localizedDescription
                if description.contains("The request timed out.") {
                    self?.isConnectionLost.value = true
                } else {
                    self?.isRequestFailed.value = true
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
