//
//  FFAlertManager.swift
//  FinFlow
//
//  Created by Vlad Todorov on 30.03.23.
//

import Foundation
import UIKit

final class FFAlertManager {
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            vc.present(alert, animated: true)
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
    public static func showProductAdded(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Success!", message: "You have successfully added a new product.")
    }
}

