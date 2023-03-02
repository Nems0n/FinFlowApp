//
//  FFStorageMainTableViewHeaderView.swift
//  FinFlow
//
//  Created by Vlad Todorov on 2.03.23.
//

import UIKit

class FFStorageMainTableViewHeaderView: UIView {

    lazy var mainTitle: UILabel = {
        lazy var label = UILabel()
        label.text = "All goods"
        label.font = .poppins(.bold, size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.frame.size.height = 84
        addSubviews()
        createConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient(colors: [UIColor.appColor(.systemGradientPurple)?.cgColor ?? UIColor.gray.cgColor,
                             UIColor.appColor(.systemGradientBlue)?.cgColor ?? UIColor.gray.cgColor], angle: 90)
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(mainTitle)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            mainTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            mainTitle.heightAnchor.constraint(equalToConstant: 24),
            mainTitle.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
}
