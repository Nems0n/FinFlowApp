//
//  AppTextField.swift
//  FinFlow
//
//  Created by Vlad Todorov on 19.04.23.
//

import Foundation
import UIKit

class AppTextField: UITextField {
    
    //MARK: - Instances
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //MARK: - Init
    init(tag: Int = 0, isSecure: Bool = false) {
        super.init(frame: .zero)
        setup(tag: tag, isSecure: isSecure)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setup(tag: Int, isSecure: Bool) {
        self.tag = tag
        self.isSecureTextEntry = isSecure
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.appColor(.systemAccentOne)?.withAlphaComponent(0.2).cgColor
        self.backgroundColor = .white
        self.textAlignment = .left
        self.font = .poppins(.regular, size: 14)
        self.textColor = .appColor(.systemBG)?.withAlphaComponent(0.6)
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
}
