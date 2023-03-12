//
//  FFProductTableViewFooterV.swift
//  FinFlow
//
//  Created by Vlad Todorov on 12.03.23.
//

import UIKit

class FFProductTableViewFooterV: UITableViewHeaderFooterView {
    //MARK: - UI Objects
    
    public static var identifier: String {
        get {
            return String(describing: self)
        }
    }
    
    lazy var viewMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("View more", for: .normal)
        button.titleLabel?.font = .poppins(.regular, size: 12)
        button.setTitleColor(.appColor(.systemBG)?.withAlphaComponent(0.8), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    //MARK: - View Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        createConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        viewMoreButton.addBorder(side: .Bottom, color: viewMoreButton.titleLabel?.textColor ?? .black, width: 1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup View
    private func addSubviews() {
        addSubview(viewMoreButton)
    }
    
    //MARK: - Create Constraints
    private func createConstraints() {
        NSLayoutConstraint.activate([
            viewMoreButton.heightAnchor.constraint(equalToConstant: 20),
            viewMoreButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            viewMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
