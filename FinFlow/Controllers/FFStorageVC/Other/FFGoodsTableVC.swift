//
//  FFGoodsTableVC.swift
//  FinFlow
//
//  Created by User Account on 06/05/2023.
//

import UIKit

class FFGoodsTableVC: UIViewController {
    
    //MARK: - Variables
    private let interfaceGridView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var navBarAppearance: UINavigationBarAppearance = {
        let app = UINavigationBarAppearance()
        app.titleTextAttributes = [NSAttributedString.Key.font: UIFont.poppins(.bold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.appColor(.systemBG) ?? UIColor.black]
        app.shadowColor = .clear
        app.backgroundColor = .white
        return app
    }()
    
    private var imageForNavBar: UIImage?
    
    private var navBarLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.appColor(.systemGradientPurple)?.cgColor ?? UIColor.white.cgColor, UIColor.appColor(.systemGradientBlue)?.cgColor ?? UIColor.white.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    var viewModel: FFStorageVM
    
    private var sortView: FFProductSortView = {
        let view = FFProductSortView()
    
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tableRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        control.tintColor = .appColor(.systemBG)?.withAlphaComponent(0.8)
        control.backgroundColor = .appColor(.systemBorder)
        return control
    }()
    
    
    lazy var mainTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(FFProductTableViewCell.self, forCellReuseIdentifier: FFProductTableViewCell.identifier)
        view.isScrollEnabled = true
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appColor(.systemBorder)?.cgColor
        view.rowHeight = 72
        view.backgroundColor = .white
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
        view.refreshControl = tableRefreshControl
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sectionHeaderTopPadding = 0
        return view
    }()
    
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
    
    private var dataSource = [FFProductCellVM?]() {
        didSet {
            self.mainTableView.reloadData()
        }
    }
    
    private var categorySortArray = [Category]() {
        didSet {
            viewModel.categorySort(with: categorySortArray)
        }
    }
    
    // MARK: - Life cycle
    init(viewModel: FFStorageVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        setupLayout()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let defaultAppearance = UINavigationBarAppearance()
        defaultAppearance.backgroundColor = .white
        defaultAppearance.shadowColor = .clear
        self.navigationController?.navigationBar.scrollEdgeAppearance = defaultAppearance
        self.navigationController?.navigationBar.standardAppearance = defaultAppearance
    }

    // MARK: - Private methods
    
    private func setupView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.appColor(.systemBG) ?? .black, renderingMode: .alwaysOriginal),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButtonDidTap))
        title = "All goods"
        view.backgroundColor = .white
        mainTableView.delegate = self
        mainTableView.dataSource = self
        sortView.priceButton.addTarget(self, action: #selector(priceSortDidTap), for: .touchUpInside)
        sortView.categoryButton.addTarget(self, action: #selector(categorySortDidTap(sender:)), for: .touchUpInside)
        sortView.categoryButton.sendActions(for: .touchUpInside)
        sortView.stockButton.addTarget(self, action: #selector(stockSortDidTap), for: .touchUpInside)
        sortView.supplierButton.addTarget(self, action: #selector(supplierSortDidTap), for: .touchUpInside)
        tableRefreshControl.addTarget(self, action: #selector(tableRefreshControlAction(sender:)), for: .valueChanged)
        
        navBarLayer.frame = CGRect(x: 0, y: 0, width: navigationController?.navigationBar.bounds.width ?? 0, height: navigationController?.navigationBar.bounds.height ?? 0)
        let bgImage = getImageFrom(gradientLayer: navBarLayer)
        imageForNavBar = bgImage
    }
    
    private func setupNavBar() {
        navBarAppearance.backgroundImage = imageForNavBar
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.standardAppearance = self.navigationController?.navigationBar.scrollEdgeAppearance ?? navBarAppearance
    }
    
    private func setupSubviews() {
        view.addSubview(sortView)
        view.addSubview(mainTableView)
    }
    
    private func setupBindings() {
        viewModel.cellDataSource.bind { [weak self] array in
            guard let self = self else { return }
            self.dataSource = array
        }
        
        viewModel.isDataReloaded.bind { [weak self] reloaded in
            if !reloaded {
                guard let self = self else { return }
                DispatchQueue.main.async {
                    FFActivityIndicatorManager.shared.showActivityIndicator(on: self.mainTableView.view)
                }
            }
            if reloaded {
                DispatchQueue.main.async {
                    FFActivityIndicatorManager.shared.stopActivityIndicator()
                }
                self?.tableRefreshControl.endRefreshing()
            }
        }
    }
    
    private func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        // Use UIGraphicsImageRenderer instead of UIGraphicsBeginImageContext to ensure that we're on the same thread
        let renderer = UIGraphicsImageRenderer(bounds: gradientLayer.frame)
        gradientImage = renderer.image { (context) in
            gradientLayer.render(in: context.cgContext)
        }.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        return gradientImage
    }
    
    private func updateCategoryArray(with item: Category, isAppend: Bool) {
        if isAppend {
            self.categorySortArray.append(item)
        } else {
            categorySortArray.removeAll { $0 == item }
        }
    }

    // MARK: - Selectors
    @objc private func backButtonDidTap() {
        viewModel.popViewController()
    }
    
    @objc private func priceSortDidTap() {
        viewModel.sortByPrice()
    }
    @objc private func categorySortDidTap(sender: Any) {
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
        viewModel.sortByStock()
    }
    
    @objc func supplierSortDidTap() {
        viewModel.sortBySupplier()
    }
    
    @objc private func tableRefreshControlAction(sender: UIRefreshControl) {
        Task {
            await viewModel.getProductsArray()
            await viewModel.getUser()
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
    
    // MARK: - Constraints
    private func setupLayout() {
        NSLayoutConstraint.activate([
            sortView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sortView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortView.widthAnchor.constraint(equalTo: view.widthAnchor),
            sortView.heightAnchor.constraint(equalToConstant: 45),
            
            mainTableView.topAnchor.constraint(equalTo: sortView.bottomAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FFGoodsTableVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Data Source & Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    /// Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FFProductTableViewCell.identifier, for: indexPath) as? FFProductTableViewCell else {
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            return cell
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = .appColor(.systemAccentOne)?.withAlphaComponent(0.05)
        cell.selectedBackgroundView = backgroundView
        guard self.dataSource.indices.contains(indexPath.row), let cellVM = self.dataSource[indexPath.row] else {
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            return cell
        }
        cell.setupCell(viewModel: cellVM)
        return cell
    }
    
    /// Did select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.dataSource.indices.contains(indexPath.row), let cellVM = self.dataSource[indexPath.row] else { return }
        let detailVM = FFStorageCellDetailVM(product: cellVM.product)
        viewModel.cellDidTap(with: detailVM)
    }
}
