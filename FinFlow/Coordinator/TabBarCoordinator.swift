//
//  TabBarCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 13.03.23.
//

import Foundation
import UIKit

protocol StartFlow {
    
}

class TabBarCoordinator: Coordinator {
    
    var rootViewController: UITabBarController
    var childCoordinators = [Coordinator]()
    
    
    init() {
        self.rootViewController = UITabBarController()
        rootViewController.tabBar.backgroundColor = .appColor(.systemBG)
        rootViewController.tabBar.unselectedItemTintColor = UIColor(white: 1, alpha: 0.7)
        rootViewController.tabBar.tintColor = .white
    }
    
    func start() {
        
        let storageCoordinator = FFStorageCoordinator()
        storageCoordinator.start()
        self.childCoordinators.append(storageCoordinator)
        let navStorage = storageCoordinator.rootViewController
        setup(vc: navStorage, title: "Storage", imageName: "shippingbox", tag: 0)
        
        let financeCoordinator = FFFinanceCoordinator()
        financeCoordinator.start()
        self.childCoordinators.append(financeCoordinator)
        let navFinance = financeCoordinator.rootViewController
        setup(vc: navFinance, title: "Finance", imageName: "dollarsign.circle", tag: 1)
        
        let promoCoordinator = FFPromoCoordinator()
        promoCoordinator.start()
        self.childCoordinators.append(promoCoordinator)
        let navPromo = promoCoordinator.rootViewController
        setup(vc: navPromo, title: "Promo", imageName: "note.text", tag: 2)
        
        let adminCoordinator = FFAdminCoordinator()
        adminCoordinator.start()
        self.childCoordinators.append(adminCoordinator)
        let navAdmin = adminCoordinator.rootViewController
        setup(vc: navAdmin, title: "Admin", imageName: "person.circle", tag: 3)
        
        self.rootViewController.viewControllers = [navStorage, navFinance, navPromo, navAdmin]
    }
    
    private func setup(vc: UIViewController, title: String, imageName: String, tag: Int) {
        let tabImage = UIImage(systemName: imageName)
        let tabBarItem = UITabBarItem(title: title, image: tabImage, tag: tag)
        vc.tabBarItem = tabBarItem
    }
}
