//
//  ViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import UIKit

final class FFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .appColor(.systemBG)
        tabBar.unselectedItemTintColor = UIColor(white: 1, alpha: 0.7)
        tabBar.tintColor = .white
        
        setUpTabs()
    }
    
    private func setUpTabs() {
        let storageVC = FFStorageViewController()
        let financeVC = FFFinanceViewController()
        let promoVC = FFPromoViewController()
        let adminVC = FFAdminViewController()

        let navStorage = UINavigationController(rootViewController: storageVC)
        let navFinance = UINavigationController(rootViewController: financeVC)
        let navPromo = UINavigationController(rootViewController: promoVC)
        let navAdmin = UINavigationController(rootViewController: adminVC)
        
        navStorage.tabBarItem = UITabBarItem(title: "Storage", image: UIImage(systemName: "shippingbox"), tag: 0)
        navFinance.tabBarItem = UITabBarItem(title: "Finance", image: UIImage(systemName: "dollarsign.circle"), tag: 1)
        navPromo.tabBarItem = UITabBarItem(title: "Promo", image: UIImage(systemName: "note.text"), tag: 2)
        navAdmin.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "person.circle"), tag: 3)
        
        setViewControllers([navStorage, navFinance, navPromo, navAdmin], animated: true)
    }

}

