//
//  FFAddProductVC.swift
//  FinFlow
//
//  Created by User Account on 16/05/2023.
//

import UIKit

class FFAddProductVC: UIViewController {
    
    // MARK: - Variables
    private var viewModel: FFAddProductVM
    
    private let interfaceGridView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Product"
        label.font = .poppins(.bold, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.85)
        label.sizeToFit()
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the product name:"
        label.font = .poppins(.regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let nameTextField: UITextField = {
        let tf = AppTextField()
        return tf
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the product category:"
        label.font = .poppins(.regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let categoryPickerView: UIPickerView = {
        let view = UIPickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appColor(.systemAccentOne)?.withAlphaComponent(0.2).cgColor
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        return view
    }()
    
    private var selectedCategory: String = ""
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the price:"
        label.font = .poppins(.regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter amount:"
        label.font = .poppins(.regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let priceTextField: UITextField = {
        let tf = AppTextField()
        tf.tag = 1
        tf.keyboardType = .numberPad
        return tf
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(.regular, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "UAH"
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.4)
        label.sizeToFit()
        return label
    }()
    
    private let amountTextField: UITextField = {
        let tf = AppTextField()
        tf.tag = 2
        tf.keyboardType = .numberPad
        return tf
    }()
    
    private let pcsLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(.regular, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "pcs"
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.4)
        label.sizeToFit()
        return label
    }()
    
    private let supplierLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter supplier:"
        label.font = .poppins(.regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let supplierTextField: UITextField = {
        let tf = AppTextField()
        tf.tag = 3
        return tf
    }()
    
    private let addButton: UIButton = {
        let button = AppGradientButton(isGradient: true, title: "Add Product", UIImage(systemName: "plus"))
        return button
    }()
    
    // MARK: - Lify cycle
    init(viewModel: FFAddProductVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        dismissKeyboard()
        addSubviews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    // MARK: - Setup view
    private func setupView() {
        view.backgroundColor = .white
        nameTextField.delegate = self
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        priceTextField.delegate = self
        amountTextField.delegate = self
        supplierTextField.delegate = self
        
        addButton.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(interfaceGridView)
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(categoryLabel)
        view.addSubview(categoryPickerView)
        view.addSubview(priceLabel)
        view.addSubview(amountLabel)
        view.addSubview(priceTextField)
        view.addSubview(currencyLabel)
        view.addSubview(amountTextField)
        view.addSubview(pcsLabel)
        view.addSubview(supplierLabel)
        view.addSubview(supplierTextField)
        view.addSubview(addButton)
    }
    
    private func setupBindings() {
        viewModel.isWrongDataEntered.bind { [weak self] show in
            guard let self = self else { return }
            if show == true {
                Task {
                    FFAlertManager.showWrongDataAlert(on: self)
                }
            }
        }
        
        viewModel.isProductAdded.bind { [weak self] show in
            guard let self = self else { return }
            if show == true {
                Task {
                    FFAlertManager.showProductAdded(on: self)
                }
            }
        }
    }
    
    // MARK: - Selectors
    @objc private func addButtonDidTap() {
        Task {
            print(selectedCategory)
            await viewModel.addNewProduct(name: nameTextField.text ?? "", category: selectedCategory, price: priceTextField.text ?? "", amount: amountTextField.text ?? "", supplier: supplierTextField.text ?? "")
        }
    }

    
    // MARK: - Constraints
    private func setupLayout() {
        NSLayoutConstraint.activate([
            interfaceGridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            interfaceGridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            interfaceGridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            interfaceGridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: interfaceGridView.topAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: interfaceGridView.centerXAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor, constant: 12),
            nameLabel.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 36),
            
            nameTextField.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            nameTextField.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 36),
            
            categoryLabel.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor, constant: 12),
            categoryLabel.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor),
            categoryLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            categoryLabel.heightAnchor.constraint(equalToConstant: 20),

            categoryPickerView.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            categoryPickerView.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor),
            categoryPickerView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            categoryPickerView.heightAnchor.constraint(equalToConstant: 36 * 2.5),
            
            priceLabel.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor, constant: 12),
            priceLabel.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor, multiplier: 0.5),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            priceLabel.topAnchor.constraint(equalTo: categoryPickerView.bottomAnchor, constant: 16),
            
            amountLabel.widthAnchor.constraint(equalTo: priceLabel.widthAnchor, constant: -12),
            amountLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 12),
            amountLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            amountLabel.heightAnchor.constraint(equalTo: priceLabel.heightAnchor),
            
            priceTextField.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            priceTextField.widthAnchor.constraint(equalTo: categoryPickerView.widthAnchor, multiplier: 0.35),
            priceTextField.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            priceTextField.heightAnchor.constraint(equalToConstant: 36),
            
            currencyLabel.leadingAnchor.constraint(equalTo: priceTextField.trailingAnchor, constant: 6),
            currencyLabel.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor),
            
            amountTextField.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            amountTextField.topAnchor.constraint(equalTo: priceTextField.topAnchor),
            amountTextField.widthAnchor.constraint(equalTo: priceTextField.widthAnchor),
            amountTextField.heightAnchor.constraint(equalTo: priceTextField.heightAnchor),
            
            pcsLabel.leadingAnchor.constraint(equalTo: amountTextField.trailingAnchor, constant: 6),
            pcsLabel.centerYAnchor.constraint(equalTo: amountTextField.centerYAnchor),
            
            supplierLabel.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 16),
            supplierLabel.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor, constant: 12),
            supplierLabel.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor),
            supplierLabel.heightAnchor.constraint(equalToConstant: 20),
            
            supplierTextField.topAnchor.constraint(equalTo: supplierLabel.bottomAnchor, constant: 4),
            supplierTextField.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            supplierTextField.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor),
            supplierTextField.heightAnchor.constraint(equalToConstant: 36),
            
            addButton.bottomAnchor.constraint(equalTo: interfaceGridView.bottomAnchor, constant: -48),
            addButton.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: interfaceGridView.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}

// MARK: - Extensions
extension FFAddProductVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
           nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
//            loginButtonDidTap()
        }
        return true
    }
}

extension FFAddProductVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Category.allCases.count
    }

    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel? = (view as? UILabel)
        let categories = Category.allCases
        if label == nil {
            label = UILabel()
            label?.font = .poppins(.regular, size: 18)
            label?.textAlignment = .center
        }
        let category = categories[row].rawValue
        label?.text = category.capitalized
        label?.textColor = .appColor(.systemBG)?.withAlphaComponent(0.6)
        guard let pickerLabel = label else { return UIView() }
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = Category.allCases[row].rawValue
        selectedCategory = category
    }
    
}
