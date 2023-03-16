//
//  FFFinanceCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 13.03.23.
//

import Foundation
import UIKit

class FFFinanceCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    lazy var financeVC = FFFinanceVC()
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([financeVC], animated: false)
    }
}
