//
//  FFStorageCoordinator.swift
//  FinFlow
//
//  Created by Vlad Todorov on 13.03.23.
//

import Foundation
import UIKit

protocol FFStorageFlow {
    func coordinateToDetail(with cell: FFProductTableViewCell)
}
class FFStorageCoordinator: Coordinator, FFStorageFlow {
    
    var rootViewController: UINavigationController
    
    lazy var storageVC = FFStorageVC()
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        storageVC.coordinator = self
        rootViewController.setViewControllers([storageVC], animated: false)
    }
    
    func coordinateToDetail(with cell: FFProductTableViewCell) {
        let storageCellDetailCoordinator = FFStorageCellDetailCoordinator(rootViewController: rootViewController)
        
        storageCellDetailCoordinator.start()
    }
}

