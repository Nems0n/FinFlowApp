//
//  FFPromoCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 13.03.23.
//

import Foundation
import UIKit

class FFPromoCoordinator: Coordinator {
    
    var rootViewController: UINavigationController
    
    lazy var promoVC = FFPromoVC()
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        rootViewController.setViewControllers([promoVC], animated: false)
    }
}
