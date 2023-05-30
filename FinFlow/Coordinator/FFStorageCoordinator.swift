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
    case login
    case allGoods(AnyObject)
    case addProduct(AnyObject)
    case bestSellers
    case pop
    case dismiss
}

protocol FFStorageCoordinatorOutput: AnyObject {
    func goToLogin()
}

class FFStorageCoordinator: NavigationCoordinator<StorageRoute> {
    
    weak var output: FFStorageCoordinatorOutput?
    
    init() {
        super.init(initialRoute: .storage)
    }
    
    override func prepareTransition(for route: StorageRoute) -> NavigationTransition {
        switch route {
        case .storage:
            let viewModel = FFStorageVM()
            viewModel.setCoordinator(coordinator: self)
            let storageVC = FFStorageVC()
            storageVC.setVM(viewModel: viewModel)
            return .push(storageVC)
            
        case .detail(let vm):
            guard let viewModel = vm as? FFStorageCellDetailVM else { return .none() }
            viewModel.setCoordinator(coordinator: self)
            let vc = FFStorageCellDetailVC()
            vc.setupVC(with: viewModel)
            return .push(vc)
            
        case .allGoods(let vm):
            guard let vm = vm as? FFStorageVM else { return .none() }
            let vc = FFGoodsTableVC(viewModel: vm)
            return .push(vc)
            
        case .addProduct(let vm):
            guard let vm = vm as? FFAddProductVM else { return .none() }
            let vc = FFAddProductVC(viewModel: vm)
            return .present(vc)
            
        case .login:
            output?.goToLogin()
            return .none()
            
        case .bestSellers:
            let vm = FFBestSellersVM(coordinator: self)
            let vc = FFBestSellersVC(viewModel: vm)
            return .push(vc)
            
        case .pop:
            return .pop()
        case .dismiss:
            return .dismiss()
        }
        
    }

    
}
