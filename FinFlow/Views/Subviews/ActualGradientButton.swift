//
//  ActualGradientButton.swift
//  FinFlow
//
//  Created by Vlad Todorov on 1.03.23.
//

import UIKit

class ActualGradientButton: UIButton {
    
    private var gradient: Bool

    override func layoutSubviews() {
          super.layoutSubviews()
          gradientLayer.frame = bounds
      }
    override var isHighlighted: Bool {
        didSet {
            if gradient {
                gradientLayer.isHidden = isHighlighted ? false : true
            } else {
                backgroundColor = isHighlighted ? UIColor.appColor(.systemAccentThree)?.withAlphaComponent(0.1) : UIColor.white
            }
        }
    }
    
    init(isGradient: Bool, title: String, _ icon: UIImage?) {
        self.gradient = isGradient
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.appColor(.systemAccentThree)?.cgColor
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .poppins(.regular, size: 12)
        self.setTitleColor(.appColor(.systemBG)?.withAlphaComponent(0.5), for: .normal)
        
        guard let image = icon else {return}
        self.setImage(image.withTintColor(.appColor(.systemBG)?.withAlphaComponent(0.5) ?? .gray, renderingMode: .alwaysOriginal), for: .normal)
        self.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(scale: .small), forImageIn: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      private lazy var gradientLayer: CAGradientLayer = {
          let gradientLayer = CAGradientLayer()
          gradientLayer.frame = self.bounds
          gradientLayer.colors = [UIColor.appColor(.systemGradientPurple)?.cgColor ?? UIColor.gray.cgColor, UIColor.appColor(.systemGradientBlue)?.cgColor ?? UIColor.gray.cgColor]
          gradientLayer.startPoint = CGPoint(x: -0.5, y: 0)
          gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
          gradientLayer.cornerRadius = 16
          layer.insertSublayer(gradientLayer, at: 0)
          gradientLayer.isHidden = true
          return gradientLayer
      }()

}
