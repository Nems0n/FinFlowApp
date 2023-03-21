//
//  FFAdminCoordinatorX.swift
//  FinFlow
//
//  Created by Vlad Todorov on 22.03.23.
//

import Foundation
import XCoordinator

enum AdminRoute: Route {
    case admin
}

class FFAdminCoordinatorX: NavigationCoordinator<AdminRoute> {
    
    lazy var adminVC = FFAdminVC()
    
    init() {
        super.init(initialRoute: .admin)
    }
    
    override func prepareTransition(for route: AdminRoute) -> NavigationTransition {
        switch route {
        case .admin:
            adminVC.coordinator = self
            return .push(adminVC)
           
        }
    }
    
}

