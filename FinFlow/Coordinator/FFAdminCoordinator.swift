//
//  FFAdminCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 13.03.23.
//

import Foundation
import UIKit

class FFAdminCoordinator: Coordinator {
 
    var rootViewController: UINavigationController
    
    lazy var adminVC = FFAdminVC()
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([adminVC], animated: false)
    }
}
