//
//  FFAlertManager.swift
//  FinFlow
//
//  Created by Vlad Todorov on 30.03.23.
//

import Foundation
import UIKit

final class FFAlertManager {
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?, isCancelAction: Bool = false, action: UIAlertAction = UIAlertAction(title: "OK", style: .default)) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if isCancelAction {
                let action = UIAlertAction(title: "Cancel", style: .cancel)
                alertController.addAction(action)
            }
            alertController.addAction(action)
            vc.present(alertController, animated: true)
        }
    }
}

//MARK: - Show Validation Alerts
extension FFAlertManager {
    public static func showInvalidLoginAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Email or Password", message: "Please try again.")
    }
    
    public static func showWrongDataAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid data", message: "Please check your data again.")
    }
}

//MARK: - Show Connection Alerts
extension FFAlertManager {
    public static func showLostConnectionAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Connection error", message: "Please check your internet connectivity.")
    }
}

// MARK: - Show Successfull Alerts
extension FFAlertManager {
    public static func showProductAdded(on vc: UIViewController, action: UIAlertAction) {
        self.showBasicAlert(on: vc, title: "Success!", message: "You have successfully added a new product.", action: action)
    }
    
    public static func showSuccessfullAction(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Success!", message: "You request was done successfully.")
    }
}

// MARK: - Show Action Alerts
extension FFAlertManager {
    public static func showProductDelete(on vc: UIViewController, action: UIAlertAction) {
        self.showBasicAlert(on: vc, title: "Delete Product", message: "Are you sure you want to delete the product?", isCancelAction: true, action: action)
    }
}
