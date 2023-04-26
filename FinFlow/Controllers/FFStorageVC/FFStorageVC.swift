//
//  FFStorageViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import UIKit

final class FFStorageVC: UIViewController {
    
    // MARK: - UI Elements
    var viewModel: FFStorageVM?
    
    private let interfaceGridView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var searchController: UISearchController?
    
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
        tf.isHidden = true
        return tf
    }()
    
    let underlineBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var searchButton: UIButton = {
//        let button = AppGradientButton(isGradient: false, title: "Search", UIImage(systemName: "magnifyingglass"))
        
//        let button = AppGradientButton(isGradient: false, title: nil, UIImage(systemName: "magnifyingglass"))
//        button.layer.cornerRadius = 12
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.setImage(UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = UIColor(white: 0, alpha: 0.4)
//        button.imageView?.contentMode = .scaleAspectFill
        button.sizeToFit()
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "finFlowInnerLogo")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var userButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
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
    
    lazy var addProductButton: AppGradientButton = {
        let button = AppGradientButton(isGradient: true, title: "Add new product", UIImage(systemName: "plus"))
        return button
    }()
    
    lazy var bestSellerButton: AppGradientButton = {
        var button = AppGradientButton(isGradient: false, title: "Best sellers", nil)
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
    
    private var tableRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        control.tintColor = .appColor(.systemBG)?.withAlphaComponent(0.8)
        return control
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
        table.refreshControl = tableRefreshControl
        return table
    }()
    
    var dataArray = [FFProductCellVM?]()
    
    private var categorySortArray = [Category]() {
        didSet {
            viewModel?.categorySort(with: categorySortArray)
        }
    }

    private var categoryStates = (cerealState: false,
                                  dairyState: false,
                                  fishState: false,
                                  fruitState: false,
                                  grainsState: false,
                                  meatState: false,
                                  snackState: false,
                                  sweetState: false,
                                  vegetablesState: false,
                                  waterState: false)
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        addSubviews()
        createConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupBindings()
        navigationItem.searchController?.searchResultsController?.view.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.isConnectionFailed.value = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.searchController?.searchBar.text = nil
    }
    
    //MARK: Injection
    public func setVM(viewModel: FFStorageVM) {
        self.viewModel = viewModel
    }
    
    //MARK: - Setup view
    private func addSubviews() {
        view.addSubview(interfaceGridView)
        view.addSubview(searchButton)
        view.addSubview(logoImageView)
        view.addSubview(userButton)
        view.addSubview(cardVContainerView)
        cardVContainerView.addSubview(cardView)
        view.addSubview(addProductButton)
        view.addSubview(bestSellerButton)
        view.addSubview(tableContainerView)
        tableContainerView.addSubview(goodsTableView)
    }
    
    private func setupElements() {
        setupSearchController()
        navigationItem.searchController = searchController
        view.backgroundColor = .systemBackground
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        searchButton.addAction(UIAction(handler: { [weak self] _ in
            UIView.performWithoutAnimation {
                self?.navigationController?.setNavigationBarHidden(false, animated: false)
                self?.searchController?.searchBar.becomeFirstResponder()
            }
        }), for: .touchDown)
        goodsTableView.delegate = self
        goodsTableView.dataSource = self
        
        addProductButton.addAction(UIAction(handler: { _ in
            self.viewModel?.addNewProduct()
            self.goodsTableView.reloadData()
            
        }), for: .touchUpInside)
        
        tableRefreshControl.addTarget(self, action: #selector(tableRefreshControlAction(sender:)), for: .valueChanged)
        bestSellerButton.addTarget(self, action: #selector(bestSellerButtonDidTap), for: .touchUpInside)
    }
    
    private func setupSearchController() {
        guard let vm = viewModel else { return }
        let resultVC = FFStorageSearchResultVC(viewModel: vm)
        searchController = UISearchController(searchResultsController: resultVC)
        searchController?.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    //MARK: - Methods
    private func setupBindings() {
        viewModel?.cellDataSource.bind { [weak self] array in
            guard let self = self else { return }
            self.dataArray = array
            self.goodsTableView.reloadData()
            var amount = Int()
            self.dataArray.forEach({ vm in
                amount += vm?.amount ?? 0
            })
            self.cardView.amountLabel.text = String(amount)
        }
        
        viewModel?.isDataReloaded.bind({ [weak self] reloaded in
            if !reloaded {
                guard let self = self else { return }
                DispatchQueue.main.async {
                    FFActivityIndicatorManager.shared.showActivityIndicator(on: self.goodsTableView.view)
                }
            }
            if reloaded {
                DispatchQueue.main.async {
                    FFActivityIndicatorManager.shared.stopActivityIndicator()
                }
                self?.tableRefreshControl.endRefreshing()
            }
        })
        
        viewModel?.isConnectionFailed.bind({ [weak self] failed in
            self?.tableRefreshControl.endRefreshing()
            if failed == true {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    FFAlertManager.showLostConnectionAlert(on: self)
                }
            }
        })
        
        viewModel?.userImageData.bind({ [weak self] data in
            guard let data = data else { return }
            let image = UIImage(data: data)
            self?.userButton.setImage(image, for: .normal)
        })
    }
    
    private func updateCategoryArray(with item: Category, isAppend: Bool) {
        if isAppend {
            self.categorySortArray.append(item)
        } else {
            categorySortArray.removeAll { $0 == item }
        }
    }
    
    //MARK: - Objc Methods
    @objc func priceSortDidTap() {
        viewModel?.sortByPrice()
    }
    
    @objc func categorySortDidTap(sender: Any) {
        guard let sender = sender as? UIButton else { return }
        let menu = UIMenu(options: .displayInline, children: [
            UIDeferredMenuElement.uncached({ [weak self] completion in
                guard let self = self else { return }
                let actions = [
                    UIAction(title: "Cereal", state: self.categoryStates.cerealState ? .on : .off) { _ in
                        print("cereal")
                        self.categoryStates.cerealState.toggle()
                        self.updateCategoryArray(with: .cereal, isAppend: self.categoryStates.cerealState ? true : false)
                    },
                    UIAction(title: "Dairy", state: self.categoryStates.dairyState ? .on : .off) { _ in
                        print("dairy")
                        self.categoryStates.dairyState.toggle()
                        self.updateCategoryArray(with: .dairy, isAppend: self.categoryStates.dairyState ? true : false)
                    },
                    UIAction(title: "Fish", state: self.categoryStates.fishState ? .on : .off) { _ in
                        print("fish")
                        self.categoryStates.fishState.toggle()
                        self.updateCategoryArray(with: .fish, isAppend: self.categoryStates.fishState ? true : false)
                    },
                    UIAction(title: "Fruit", state: self.categoryStates.fruitState ? .on : .off) { _ in
                        print("fruit")
                        self.categoryStates.fruitState.toggle()
                        self.updateCategoryArray(with: .fruit, isAppend: self.categoryStates.fruitState ? true : false)
                    },
                    UIAction(title: "Grains", state: self.categoryStates.grainsState ? .on : .off) { _ in
                        print("grains")
                        self.categoryStates.grainsState.toggle()
                        self.updateCategoryArray(with: .grains, isAppend: self.categoryStates.grainsState ? true : false)
                    },
                    UIAction(title: "Meat", state: self.categoryStates.meatState ? .on : .off) { _ in
                        print("meat")
                        self.categoryStates.meatState.toggle()
                        self.updateCategoryArray(with: .meat, isAppend: self.categoryStates.meatState ? true : false)
                    },
                    UIAction(title: "Snack", state: self.categoryStates.snackState ? .on : .off) { _ in
                        print("snack")
                        self.categoryStates.snackState.toggle()
                        self.updateCategoryArray(with: .snack, isAppend: self.categoryStates.snackState ? true : false)
                    },
                    UIAction(title: "Sweet", state: self.categoryStates.sweetState ? .on : .off) { _ in
                        print("sweet")
                        self.categoryStates.sweetState.toggle()
                        self.updateCategoryArray(with: .sweet, isAppend: self.categoryStates.sweetState ? true : false)
                    },
                    UIAction(title: "Vegetables", state: self.categoryStates.vegetablesState ? .on : .off) { _ in
                        print("vegetables")
                        self.categoryStates.vegetablesState.toggle()
                        self.updateCategoryArray(with: .vegetables, isAppend: self.categoryStates.vegetablesState ? true : false)
                    },
                    UIAction(title: "Water", state: self.categoryStates.waterState ? .on : .off) { _ in
                        print("water")
                        self.categoryStates.waterState.toggle()
                        self.updateCategoryArray(with: .water, isAppend: self.categoryStates.waterState ? true : false)
                    }
                ]
                completion(actions)
            })
        ])
        sender.menu = menu
    }
    
    @objc func stockSortDidTap() {
        viewModel?.sortByStock()
    }
    
    @objc func supplierSortDidTap() {
        viewModel?.sortBySupplier()
    }
    
    @objc func bestSellerButtonDidTap() {
        viewModel?.bestSellerDidTap()
    }
    
    @objc private func tableRefreshControlAction(sender: UIRefreshControl) {
        Task {
            await viewModel?.getProductsArray()
            await viewModel?.getUser()
        }
 
        categoryStates.cerealState = false
        categoryStates.dairyState = false
        categoryStates.fishState = false
        categoryStates.fruitState = false
        categoryStates.grainsState = false
        categoryStates.meatState = false
        categoryStates.snackState = false
        categoryStates.sweetState = false
        categoryStates.vegetablesState = false
        categoryStates.waterState = false
        
        categorySortArray.removeAll()
//        sender.endRefreshing()
    }
    
    //MARK: - Add constraints
    private func createConstraints() {
        NSLayoutConstraint.activate([
            interfaceGridView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 6),
            interfaceGridView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 26),
            interfaceGridView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            interfaceGridView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            userButton.trailingAnchor.constraint(equalTo: interfaceGridView.trailingAnchor),
            userButton.topAnchor.constraint(equalTo: interfaceGridView.topAnchor),
            userButton.heightAnchor.constraint(equalToConstant: 40),
            userButton.widthAnchor.constraint(equalTo: userButton.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: interfaceGridView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: userButton.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: interfaceGridView.leadingAnchor),
            searchButton.widthAnchor.constraint(equalTo: userButton.widthAnchor, multiplier: 1),
            searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor),
            searchButton.topAnchor.constraint(equalTo: userButton.topAnchor)
        ])

        NSLayoutConstraint.activate([
            cardVContainerView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 24),
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
//            addProductButton.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
            addProductButton.heightAnchor.constraint(equalToConstant: 36) //36
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
}
// MARK: - Extension for SearchController
extension FFStorageVC: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
        viewModel?.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Extension for TextField
extension FFStorageVC: UIBarPositioningDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
