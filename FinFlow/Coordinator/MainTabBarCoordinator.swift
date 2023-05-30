//
//  TabBarCoordinatorX.swift
//  FinFlow
//
//  Created by Vlad Todorov on 18.03.23.
//

import Foundation
import UIKit
import XCoordinator

enum TabBarRoute: Route {
    case storage, finance, promo
}

protocol MainTabBarCoordinatorOutput: AnyObject {
    func goToLogin()
}

class MainTabBarCoordinator: TabBarCoordinator<TabBarRoute> {
    
    weak var output: MainTabBarCoordinatorOutput?
    
    private let storageRouter: StrongRouter<StorageRoute>
//    private let financeRouter: StrongRouter<FinanceRoute>
//    private let promoRouter: StrongRouter<PromoRoute>
//    private let adminRouter: StrongRouter<AdminRoute>
    
    convenience init() {
        let storageCoordinator = FFStorageCoordinator()
        storageCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Storage", image: UIImage(systemName: "shippingbox"), tag: 0)
        
//        let financeCoordinator = FFFinanceCoordinator()
//        financeCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Finance", image: UIImage(systemName: "dollarsign.circle"), tag: 1)
//
//        let promoCoordinator = FFPromoCoordinator()
//        promoCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Promo", image: UIImage(systemName: "note.text"), tag: 2)
//
//        let adminCoordinator = FFAdminCoordinator()
//        adminCoordinator.rootViewController.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "person.circle"), tag: 3)
        
        self.init(storageRouter: storageCoordinator.strongRouter/*,
                 financeRouter: financeCoordinator.strongRouter,
                  promoRouter: promoCoordinator.strongRouter,
                  adminRouter: adminCoordinator.strongRouter*/)
        
        storageCoordinator.output = self
    }
    
    init(storageRouter: StrongRouter<StorageRoute>/*,
         financeRouter: StrongRouter<FinanceRoute>,
         promoRouter: StrongRouter<PromoRoute>,
         adminRouter: StrongRouter<AdminRoute>*/) {
        
        self.storageRouter = storageRouter
//        self.financeRouter = financeRouter
//        self.promoRouter = promoRouter
//        self.adminRouter = adminRouter
        
        super.init(tabs: [storageRouter/*, financeRouter, promoRouter, adminRouter*/], select: storageRouter)
//        rootViewController.tabBar.backgroundColor = .appColor(.systemBG)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .appColor(.systemBG)
          
        rootViewController.tabBar.standardAppearance = appearance
        rootViewController.tabBar.scrollEdgeAppearance = rootViewController.tabBar.standardAppearance
        rootViewController.tabBar.unselectedItemTintColor = UIColor(white: 1, alpha: 0.7)
        rootViewController.tabBar.tintColor = .white
    }
}


extension MainTabBarCoordinator: FFStorageCoordinatorOutput {
    func goToLogin() {
        output?.goToLogin()
    }
}
