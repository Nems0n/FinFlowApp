//
//  FFLoginCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.03.23.
//

import Foundation
import XCoordinator

enum LoginRoute: Route {
    case login
}

class FFLoginCoordinator: NavigationCoordinator<LoginRoute> {
        
    init() {
        super.init(initialRoute: .login)
    }
    
    override func prepareTransition(for route: LoginRoute) -> NavigationTransition {
        switch route {
        case .login:
            let viewModel = FFLoginVM()
//            viewModel.setCoordinator(coordinator: self)
            let loginVC = FFLoginVC()
            loginVC.setVM(viewModel: viewModel)
            return .push(loginVC)
        }
    }
}
