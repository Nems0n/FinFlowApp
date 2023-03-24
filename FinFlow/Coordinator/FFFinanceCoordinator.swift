//
//  FFFinanceCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 19.03.23.
//

import Foundation
import XCoordinator

enum FinanceRoute: Route {
    case finance
    case detail(UIViewController)
    case detailOfDetail(UIViewController)
}

class FFFinanceCoordinator: NavigationCoordinator<FinanceRoute> {
    
    init() {
        super.init(initialRoute: .finance)
    }
    
    override func prepareTransition(for route: FinanceRoute) -> NavigationTransition {
        switch route {
        case .finance:
            let financeVC = FFFinanceVC()
            financeVC.coordinator = self
            return .push(financeVC)
            
        case .detail(let vc):
            return .push(vc)
            
        case .detailOfDetail(let vc):
            return .push(vc)
            
        }
    }
}
