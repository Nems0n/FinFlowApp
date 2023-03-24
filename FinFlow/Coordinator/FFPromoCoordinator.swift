//
//  FFPromoCoordinatorX.swift
//  FinFlow
//
//  Created by Vlad Todorov on 22.03.23.
//

import Foundation
import XCoordinator

enum PromoRoute: Route {
    case promo
}

class FFPromoCoordinator: NavigationCoordinator<PromoRoute> {
    
    lazy var promoVC = FFPromoVC()
    
    init() {
        super.init(initialRoute: .promo)
    }
    
    override func prepareTransition(for route: PromoRoute) -> NavigationTransition {
        switch route {
        case .promo:
            promoVC.coordinator = self
            return .push(promoVC)
           
        }
    }
    
}
