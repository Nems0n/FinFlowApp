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
}
