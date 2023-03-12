//
//  FFStorageViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import UIKit

final class FFStorageVC: UIViewController {
    //MARK: - UI Elements
    var viewModel: FFStorageVM = FFStorageVM()
    
    private let interfaceGridView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchController: UISearchController = {
        let resultVC = FFStorageSearchResultVC()
        let sc = UISearchController(searchResultsController: resultVC)
        return sc
    }()
    
    let searchTextField: UITextField = {
        let tf = UITextField()
        let imageContainer =  UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        imageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0, alpha: 0.2)
        imageView.contentMode = .scaleAspectFit
        imageContainer.addSubview(imageView)
        tf.leftViewMode = .always
        tf.leftView = imageContainer
        tf.textColor = UIColor(white: 0, alpha: 0.2)
        tf.attributedPlaceholder = NSAttributedString(string: "Start typing...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.2)])
        tf.font = .poppins(.regular, size: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isContextMenuInteractionEnabled = false
        return tf
    }()
    
    let underlineBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "testAvatar") {
            button.setImage(image, for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
        }
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cardVContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.appColor(.systemAccentOne)?.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.15
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var cardView: FFMainViewCardV = {
        let view = FFMainViewCardV()
        return view
    }()
    
    lazy var addProductButton: ActualGradientButton = {
        let button = ActualGradientButton(isGradient: true, title: "Add new product", UIImage(systemName: "plus"))
        return button
    }()
    
    lazy var bestSellerButton: ActualGradientButton = {
        var button = ActualGradientButton(isGradient: false, title: "Best sellers", nil)
        return button
    }()
    
    private let tableContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.appColor(.systemAccentOne)?.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 12
        view.layer.shadowOpacity = 0.15
        view.layer.masksToBounds = false
        return view
    }()
    
    lazy var goodsTableView: UITableView = {
        var table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FFProductTableViewCell.self, forCellReuseIdentifier: FFProductTableViewCell.identifier)
        table.register(FFProductTableViewHeader.self, forHeaderFooterViewReuseIdentifier: FFProductTableViewHeader.identifier)
        table.register(FFProductTableViewFooterV.self, forHeaderFooterViewReuseIdentifier: FFProductTableViewFooterV.identifier)
        table.clipsToBounds = true
        table.layer.cornerRadius = 16
        table.sectionHeaderTopPadding = 0
        table.isScrollEnabled = true
        table.layer.borderWidth = 1
        table.layer.borderColor = UIColor.appColor(.systemBorder)?.cgColor
        table.rowHeight = 72
        table.backgroundColor = .white
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        return table
    }()
    
    var dataArray = [FFProductCellVM?]()
    //MARK: - VC Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.mapCellData()
        setupElements()
        addSubviews()
        createConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBindings()
    }

    
    //MARK: - Setup view
    private func addSubviews() {
        view.addSubview(interfaceGridView)
        searchTextField.addSubview(underlineBorder)
        view.addSubview(searchTextField)
        view.addSubview(userButton)
        view.addSubview(cardVContainerView)
        cardVContainerView.addSubview(cardView)
        view.addSubview(addProductButton)
        view.addSubview(bestSellerButton)
        view.addSubview(tableContainerView)
        tableContainerView.addSubview(goodsTableView)
    }
    
    private func setupElements() {
    
        navigationItem.searchController = searchController
        view.backgroundColor = .systemBackground
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        searchTextField.delegate = self
        goodsTableView.delegate = self
        goodsTableView.dataSource = self
        
        addProductButton.addAction(UIAction(handler: { _ in
            self.viewModel.addNewProduct()
            self.goodsTableView.reloadData()
            
        }), for: .touchUpInside)
        
        userButton.addAction(UIAction(handler: { [weak self] _ in
            self?.viewModel.priceTouch()
        }), for: .touchUpInside)
    }
    
    //MARK: - Methods
    func setupBindings() {
        viewModel.cellDataSource.bind { [weak self] array in
            guard let self = self else { return }
            self.dataArray = array
            self.goodsTableView.reloadData()
        }
    }
   
    //MARK: - Add constraints
    private func createConstraints() {
        NSLayoutConstraint.activate([
            interfaceGridView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            interfaceGridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            interfaceGridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            interfaceGridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            userButton.trailingAnchor.constraint(equalTo: interfaceGridView.trailingAnchor),
            userButton.topAnchor.constraint(equalTo: interfaceGridView.topAnchor),
            userButton.heightAnchor.constraint(equalToConstant: 40),
            userButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: userButton.leadingAnchor, constant: -26),
            searchTextField.heightAnchor.constraint(equalTo: userButton.heightAnchor),
            searchTextField.topAnchor.constraint(equalTo: userButton.topAnchor)
        ])
        NSLayoutConstraint.activate([
            underlineBorder.heightAnchor.constraint(equalToConstant: 1),
            underlineBorder.widthAnchor.constraint(equalTo: searchTextField.widthAnchor),
            underlineBorder.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: -1),
            underlineBorder.leftAnchor.constraint(equalTo: searchTextField.leftAnchor)
        ])
        NSLayoutConstraint.activate([
            cardVContainerView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 24),
            cardVContainerView.trailingAnchor.constraint(equalTo: interfaceGridView.trailingAnchor),
            cardVContainerView.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            cardVContainerView.heightAnchor.constraint(equalToConstant: 84),
            cardView.topAnchor.constraint(equalTo: cardVContainerView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: cardVContainerView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: cardVContainerView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: cardVContainerView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            addProductButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 24),
            addProductButton.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            addProductButton.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor, multiplier: 0.48),
            addProductButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        NSLayoutConstraint.activate([
            bestSellerButton.centerYAnchor.constraint(equalTo: addProductButton.centerYAnchor),
            bestSellerButton.trailingAnchor.constraint(equalTo: interfaceGridView.trailingAnchor),
            bestSellerButton.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor, multiplier: 0.48),
            bestSellerButton.heightAnchor.constraint(equalTo: addProductButton.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            tableContainerView.topAnchor.constraint(equalTo: bestSellerButton.bottomAnchor, constant: 24),
            tableContainerView.widthAnchor.constraint(equalTo: interfaceGridView.widthAnchor),
            tableContainerView.centerXAnchor.constraint(equalTo: interfaceGridView.centerXAnchor),
            tableContainerView.bottomAnchor.constraint(equalTo: interfaceGridView.bottomAnchor, constant: -24),
            goodsTableView.topAnchor.constraint(equalTo: tableContainerView.topAnchor),
            goodsTableView.bottomAnchor.constraint(equalTo: tableContainerView.bottomAnchor),
            goodsTableView.leadingAnchor.constraint(equalTo: tableContainerView.leadingAnchor),
            goodsTableView.trailingAnchor.constraint(equalTo: tableContainerView.trailingAnchor)
        ])
    }
    
    //MARK: - Objc Methods
    @objc func priceTouched() {
        self.dataArray.reverse()
        DispatchQueue.main.async {
            self.goodsTableView.reloadData()
        }
    }
}

//MARK: - Extension for SearchController
extension FFStorageVC: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isHidden = true
    }
}
//MARK: - Extension for TextField
extension FFStorageVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            self.searchTextField.resignFirstResponder()
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
        return true
    }
}
//MARK: - Extension for TableView ...(separate later)
extension FFStorageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FFProductTableViewCell.identifier, for: indexPath) as? FFProductTableViewCell else {
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            return cell
        }
        
        guard self.dataArray.indices.contains(indexPath.row), let cellVMM = self.dataArray[indexPath.row] else { return UITableViewCell() }
        cell.setupCell(viewModel: cellVMM)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewHeader.identifier) as? FFProductTableViewHeader else {
            return UIView()
        }
        view.priceButton.addTarget(self, action: #selector(priceTouched), for: .touchUpInside)

        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewFooterV.identifier) as? FFProductTableViewFooterV else {
            return UIView()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

}

