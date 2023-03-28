//
//  FFLoginVM.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.03.23.
//

import Foundation

final class FFLoginVM: NSObject {
    var coordinator: FFLoginCoordinator?
    
    //Injection
    public func setCoordinator(coordinator: FFLoginCoordinator) {
        self.coordinator = coordinator
    }
    
}
