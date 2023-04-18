//
//  FFStorageCellDetailViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 14.03.23.
//

import UIKit

class FFStorageCellDetailVC: UIViewController {
    
    //MARK: - UI Elements
    var viewModel: FFStorageCellDetailVM?
    
    private let gridView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.systemBG)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.4)
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var supplierLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.4)
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var amountAbbreviation: String = "pcs"
    private var amountNumberString: String?
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.4)
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var currencyAbbreviation: String = "UAH"
    private var priceNumberString: String?
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.4)
        label.font = .poppins(.regular, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .right
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let promotionButton: AppGradientButton = {
        let button = AppGradientButton(isGradient: false, title: "Add Promotion", UIImage(systemName: "plus"))
        return button
    }()
    
    private let deleteButton: AppGradientButton = {
        let button = AppGradientButton(isGradient: false, title: "Delete Product", UIImage(systemName: "multiply"))
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controllerSetup()
        addSubviews()
        addConstraints()
    }
    
    
    //MARK: - UI Setup
    
    private func controllerSetup() {
        view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.appColor(.systemBG) ?? .black,
                                                                                                                          renderingMode: .alwaysOriginal),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButtonDidTap))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))?.withTintColor(.appColor(.systemAccentOne)?.withAlphaComponent(0.6) ?? .black, renderingMode: .alwaysOriginal),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(editButtonDidTap))
        
        promotionButton.addTarget(self, action: #selector(addPromotionDidTap), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteProductDidTap), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(gridView)
        view.addSubview(nameLabel)
        view.addSubview(categoryLabel)
        view.addSubview(supplierLabel)
        view.addSubview(amountLabel)
        view.addSubview(priceLabel)
        view.addSubview(promotionButton)
        view.addSubview(deleteButton)
    }
    
    //MARK: - Public Methods
    public func setupVC(with viewModel: FFStorageCellDetailVM) {
        self.viewModel = viewModel
        
        self.nameLabel.text = viewModel.name
        self.categoryLabel.text = viewModel.category.rawValue
        self.supplierLabel.text = viewModel.supplier
        self.amountNumberString = String(viewModel.amount)
        guard amountNumberString != nil else { return }
        amountLabel.text = self.amountNumberString! + " " + self.amountAbbreviation
        splitColorTextForLabel(amountString: self.amountNumberString, valueString: self.amountAbbreviation, labelToEdit: amountLabel)
        
        self.priceNumberString = String(viewModel.price)
        guard priceNumberString != nil else { return }
        priceLabel.text = self.priceNumberString! + " " + self.currencyAbbreviation
        splitColorTextForLabel(amountString: self.priceNumberString, valueString: self.currencyAbbreviation, labelToEdit: priceLabel)
    }
    
    //MARK: - Private Methods
    private func splitColorTextForLabel(amountString: String?, valueString: String, labelToEdit: UILabel) {
        let attributedText = NSMutableAttributedString(string: labelToEdit.text ?? "")
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: getRangeOfSubString(subString: amountString ?? "", fromString: labelToEdit.text ?? ""))
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: getRangeOfSubString(subString: valueString, fromString: labelToEdit.text ?? ""))
        labelToEdit.attributedText = attributedText
    }
    
    private func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
        let sampleLinkRange = fromString.range(of: subString)!
        let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
        let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
        let linkRange = NSMakeRange(startPos, endPos - startPos)
        return linkRange
    }
    
    //MARK: - Selectors
    @objc private func backButtonDidTap() {
        viewModel?.backButtonDidTap()
    }
    
    @objc private func editButtonDidTap() {
        
    }
    
    @objc private func addPromotionDidTap() {
        print("Added promotion")
    }
    
    @objc private func deleteProductDidTap() {
        print("Deleted")
    }
    
    //MARK: - Constraints
    private func addConstraints() {
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            gridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            
            nameLabel.leadingAnchor.constraint(equalTo: gridView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: gridView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: gridView.topAnchor, constant: 26),
            
            categoryLabel.leadingAnchor.constraint(equalTo: gridView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: gridView.trailingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            supplierLabel.leadingAnchor.constraint(equalTo: gridView.leadingAnchor),
            supplierLabel.trailingAnchor.constraint(equalTo: gridView.trailingAnchor),
            supplierLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            
            amountLabel.trailingAnchor.constraint(equalTo: gridView.trailingAnchor),
            amountLabel.topAnchor.constraint(equalTo: supplierLabel.bottomAnchor, constant: 20),
            
            priceLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -32),
            priceLabel.topAnchor.constraint(equalTo: amountLabel.topAnchor),
            
            promotionButton.leadingAnchor.constraint(equalTo: gridView.leadingAnchor),
            promotionButton.widthAnchor.constraint(equalTo: gridView.widthAnchor, multiplier: 0.48),
            promotionButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 40),
            promotionButton.heightAnchor.constraint(equalToConstant: 36),
            
            deleteButton.trailingAnchor.constraint(equalTo: gridView.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalTo: promotionButton.widthAnchor),
            deleteButton.heightAnchor.constraint(equalTo: promotionButton.heightAnchor),
            deleteButton.centerYAnchor.constraint(equalTo: promotionButton.centerYAnchor)
        ])
    }
}
