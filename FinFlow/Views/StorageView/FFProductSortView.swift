//
//  FFProductSortView.swift
//  FinFlow
//
//  Created by User Account on 13/05/2023.
//

import UIKit

class FFProductSortView: UIView {

    let gradientLayerView: UIView = UIView()
    let gradientLayer = CAGradientLayer()

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
     init() {
        super.init(frame: .zero)
        addSubviews()
        createConstraints()
        
        if #available(iOS 14.0, *) {
                var bgConfig = UIBackgroundConfiguration.listPlainCell()
                bgConfig.backgroundColor = UIColor.clear
                UITableViewHeaderFooterView.appearance().backgroundConfiguration = bgConfig
                
            }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayerView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        setGradient(colors: [UIColor.appColor(.systemGradientPurple)?.cgColor ?? UIColor.gray.cgColor,
                             UIColor.appColor(.systemGradientBlue)?.cgColor ?? UIColor.gray.cgColor], angle: 90, gradientLayerView: gradientLayerView, gradient: gradientLayer)

    }



    //MARK: - Setup view
    private func addSubviews() {
        addSubview(filterButtonsView)
        addSubview(priceButton)
        addSubview(categoryButton)
        addSubview(stockButton)
        addSubview(supplierButton)
    }

    //MARK: - Create Constraints
    private func createConstraints() {
        
        NSLayoutConstraint.activate([
            filterButtonsView.widthAnchor.constraint(equalTo: widthAnchor),
            filterButtonsView.heightAnchor.constraint(equalTo: heightAnchor),
            filterButtonsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterButtonsView.centerYAnchor.constraint(equalTo: centerYAnchor)
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
