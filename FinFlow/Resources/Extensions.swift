//
//  Extensions.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import Foundation
import UIKit

enum AssetsColor: String {
    case systemBG = "systemBG"
}

enum poppinsType: String {
    case bold = "Poppins-Bold"
    case medium = "Poppins-Medium"
    case regular = "Poppins-Regular"
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}

extension UIFont {
    static func poppins(_ type: poppinsType, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else { return UIFont.systemFont(ofSize: size) }
        return font
    }
    
}
