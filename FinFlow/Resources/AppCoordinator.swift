//
//  AppCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 12.03.23.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    } 
    
    func start() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.start()
        self.childCoordinators = [tabBarCoordinator]
        self.window.rootViewController = tabBarCoordinator.rootViewController
        window.makeKeyAndVisible()
       
    }
}

