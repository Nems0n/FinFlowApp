//
//  Extensions.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import Foundation
import UIKit

//MARK: - Add main app colors
extension UIColor {
    enum AssetsColor: String {
        case systemBG = "systemBG"
        case systemGradientPurple = "systemGradientPurple"
        case systemGradientBlue = "systemGradientBlue"
        case systemBorder = "systemBorder"
        case systemAccentThree = "systemAccentThree"
    }
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
//MARK: - Setup Poppins Font
extension UIFont {
    enum poppinsType: String {
        case bold = "Poppins-Bold"
        case medium = "Poppins-Medium"
        case regular = "Poppins-Regular"
    }
    
    static func poppins(_ type: poppinsType, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.rawValue, size: size) else { return UIFont.systemFont(ofSize: size) }
        return font
    }
    
}
//MARK: - Quick way to create CAGradientLayer for UIView
extension UIView {
    func setGradient(colors: [CGColor], angle: Float) {
        let gradientLayerView: UIView = UIView(frame: CGRect(x:0, y: 0, width: bounds.width, height: bounds.height))
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientLayerView.bounds
        gradient.colors = colors

        let alpha: Float = angle / 360
        let startPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.75) / 2)),
            2
        )
        let startPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0) / 2)),
            2
        )
        let endPointX = powf(
            sinf(2 * Float.pi * ((alpha + 0.25) / 2)),
            2
        )
        let endPointY = powf(
            sinf(2 * Float.pi * ((alpha + 0.5) / 2)),
            2
        )

        gradient.endPoint = CGPoint(x: CGFloat(endPointX),y: CGFloat(endPointY))
        gradient.startPoint = CGPoint(x: CGFloat(startPointX), y: CGFloat(startPointY))

        gradientLayerView.layer.insertSublayer(gradient, at: 0)
        layer.insertSublayer(gradientLayerView.layer, at: 0)
    }
    
    

}


extension UIButton {
    func setHeaderButton(title: String, image: UIImage?) {
        self.setTitle(title, for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.font = .poppins(.regular, size: 12)
        self.setTitleColor(.appColor(.systemBG)?.withAlphaComponent(0.6), for: .normal)
        self.setImage(image?.withTintColor(.appColor(.systemBG)?.withAlphaComponent(0.6) ?? .gray, renderingMode: .alwaysOriginal), for: .normal)
        self.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small), forImageIn: .normal)
        self.semanticContentAttribute = .forceRightToLeft
//        self.sizeToFit()
    }
}
