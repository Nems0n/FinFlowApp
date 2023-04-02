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
    
    init() {
        super.init(initialRoute: .main)
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
            
            return .set([tabBarCoordinator])
        }
        
    }
}
