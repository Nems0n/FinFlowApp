//
//  MainCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 18.03.23.
//

import Foundation
import XCoordinator

enum AppRoute: Route {
    case login
    case main
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    private var route: AppRoute
    
    init() {
        if FFKeychainManager.shared.read(service: .tokenJWT, account: .finFlow, type: TokenJWT.self) != nil {
            route = .main
        } else {
            route = .login
        }
        super.init(initialRoute: route)
        rootViewController.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .login:
            let viewModel = FFLoginVM()
            viewModel.setCoordinator(coordinator: self)
            
            let loginVC = FFLoginVC()
            
            loginVC.setVM(viewModel: viewModel)
            return .push(loginVC)
        case .main:
            let tabBarCoordinator = MainTabBarCoordinator()
            tabBarCoordinator.output = self
            
            return .set([tabBarCoordinator])
        }
        
    }
}


extension AppCoordinator: MainTabBarCoordinatorOutput {
    func goToLogin() {
        DispatchQueue.main.async {
            self.trigger(.login)
        }
    }
}
