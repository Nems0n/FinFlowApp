//
//  FFLoginVM.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.03.23.
//

import Foundation

final class FFLoginVM: NSObject {
    var coordinator: AppCoordinator?
    
    var email: String?
    var password: String?
    
    //Injection
    public func setCoordinator(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - Methods
    public func loginButtonAction() {
        let loginBody = AuthRequest(email: email, password: password, username: nil, phone: nil)
        print("request started")
        let request = FFRequest(endpoint: .login, httpMethod: .post, httpBody: loginBody)
        FFService.shared.execute(request, expecting: Token.self) { [weak self] result in
            switch result {
            case .success(let token):
                
                DispatchQueue.main.async {
                    
                    print(token)
                    self?.coordinator?.trigger(.main)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
