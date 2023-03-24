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
    case detail(AnyObject)
    case pop
}

class FFStorageCoordinator: NavigationCoordinator<StorageRoute> {
    
    init() {
        super.init(initialRoute: .storage)
    }
    
    override func prepareTransition(for route: StorageRoute) -> NavigationTransition {
        switch route {
        case .storage:
            let viewModel = FFStorageVM()
            viewModel.setCoordinator(coordinator: self)
            let storageVC = FFStorageVC()
            storageVC.viewModel = viewModel
            return .push(storageVC)
            
        case .detail(let vm):
            guard let viewModel = vm as? FFStorageCellDetailVM else { return .none() }
            viewModel.setCoordinator(coordinator: self)
            let vc = FFStorageCellDetailVC()
            vc.setupVC(with: viewModel)
            return .push(vc)
            
        case .pop:
            return .pop()
        }
        
    }

    
}
