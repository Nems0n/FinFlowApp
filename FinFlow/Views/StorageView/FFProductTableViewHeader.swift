//
//  FFStorageMainTableViewHeaderView.swift
//  FinFlow
//
//  Created by Vlad Todorov on 2.03.23.
//

import UIKit

class FFProductTableViewHeader: UITableViewHeaderFooterView {
    //MARK: - UI Objects
    
    public static var identifier: String {
        get {
            return String(describing: self)
        }
    }
    

    let gradientLayerView: UIView = UIView()
    let gradientLayer = CAGradientLayer()
    
    lazy var mainTitle: UILabel = {
        lazy var label = UILabel()
        label.text = "All goods"
        label.font = .poppins(.bold, size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filterButtonsView: UIView = {
        let view = UIView()
        view.alpha =  0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var priceButton: UIButton = {
        let button = UIButton()
        button.setHeaderButton(title: "Price", image: UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)))
        return button
    }()
    
    lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.setHeaderButton(title: "Category", image: UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)))
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var stockButton: UIButton = {
        let button = UIButton()
        button.setHeaderButton(title: "Stock", image: UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)))
        return button
    }()
    
    lazy var supplierButton: UIButton = {
        let button = UIButton()
        button.setHeaderButton(title: "Supplier", image: UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .thin)))
        return button
    }()
    
    lazy var sortButtonsArray = [UIButton]()
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        createConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayerView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        setGradient(colors: [UIColor.appColor(.systemGradientPurple)?.cgColor ?? UIColor.gray.cgColor,
                             UIColor.appColor(.systemGradientBlue)?.cgColor ?? UIColor.gray.cgColor], angle: 90, gradientLayerView: gradientLayerView, gradient: gradientLayer)
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    }
    //MARK: - Setup view
    private func addSubviews() {
        addSubview(mainTitle)
        addSubview(filterButtonsView)
        addSubview(priceButton)
        addSubview(categoryButton)
        addSubview(stockButton)
        addSubview(supplierButton)
    }
    
    //MARK: - Create Constraints
    private func createConstraints() {
        NSLayoutConstraint.activate([
            mainTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            mainTitle.heightAnchor.constraint(equalToConstant: 24),
            mainTitle.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            filterButtonsView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            filterButtonsView.heightAnchor.constraint(equalToConstant: 20),
            filterButtonsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterButtonsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            priceButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            priceButton.heightAnchor.constraint(equalTo: filterButtonsView.heightAnchor),
            priceButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceButton.bottomAnchor.constraint(equalTo: filterButtonsView.bottomAnchor),
            
            categoryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            categoryButton.heightAnchor.constraint(equalTo: filterButtonsView.heightAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: priceButton.trailingAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: filterButtonsView.bottomAnchor),
            
            stockButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            stockButton.heightAnchor.constraint(equalTo: filterButtonsView.heightAnchor),
            stockButton.leadingAnchor.constraint(equalTo: categoryButton.trailingAnchor),
            stockButton.bottomAnchor.constraint(equalTo: filterButtonsView.bottomAnchor),
            
            supplierButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25),
            supplierButton.heightAnchor.constraint(equalTo: filterButtonsView.heightAnchor),
            supplierButton.leadingAnchor.constraint(equalTo: stockButton.trailingAnchor),
            supplierButton.bottomAnchor.constraint(equalTo: filterButtonsView.bottomAnchor)
        ])
        
    }
    
}
