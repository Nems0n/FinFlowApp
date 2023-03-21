//
//  FFStorageCoordinatorX.swift
//  FinFlow
//
//  Created by Vlad Todorov on 18.03.23.
//

import Foundation
import XCoordinator

enum StorageRoute: Route {
    case storage
    case detail(UIViewController)
}

class FFStorageCoordinator: NavigationCoordinator<StorageRoute> {
    
    init() {
        super.init(initialRoute: .storage)
    }
    
    override func prepareTransition(for route: StorageRoute) -> NavigationTransition {
        switch route {
        case .storage:
            let storageVC = FFStorageVC()
            storageVC.coordinator = self
            return .push(storageVC)
        case .detail(let vc):    
            return .push(vc)
           
        }
    }
    
}
