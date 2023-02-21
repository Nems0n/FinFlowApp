//
//  Extensions.swift
//  FinanceFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import Foundation
import UIKit

enum AssetsColor: String {
    case systemBG = "systemBG"
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
