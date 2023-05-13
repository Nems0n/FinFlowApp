//
//  FFGoodsTableVC.swift
//  FinFlow
//
//  Created by User Account on 06/05/2023.
//

import UIKit

class FFGoodsTableVC: UIViewController {
    
    //MARK: - Variables
    private var navBarLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.appColor(.systemGradientPurple)?.cgColor ?? UIColor.white.cgColor, UIColor.appColor(.systemGradientBlue)?.cgColor ?? UIColor.white.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        return layer
    }()
    
    var viewModel: FFStorageVM
    
    private var tableRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        control.tintColor = .appColor(.systemBG)?.withAlphaComponent(0.8)
        return control
    }()
    
    lazy var mainTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(FFProductTableViewCell.self, forCellReuseIdentifier: FFProductTableViewCell.identifier)
        view.register(FFProductTableViewHeader.self, forHeaderFooterViewReuseIdentifier: FFProductTableViewHeader.identifier)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
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
//        self.edgesForExtendedLayout = UIRectEdge()
//        self.extendedLayoutIncludesOpaqueBars = false
        
    }
    
    private func setupNavBar() {
        navBarLayer.frame = CGRect(x: 0, y: 0, width: navigationController?.navigationBar.bounds.width ?? 0, height: navigationController?.navigationBar.bounds.height ?? 0)
        let bgImage = getImageFrom(gradientLayer: navBarLayer)
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.poppins(.bold, size: 16), NSAttributedString.Key.foregroundColor: UIColor.appColor(.systemBG) ?? UIColor.black]
        appearance.backgroundImage = bgImage
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupSubviews() {
        view.addSubview(mainTableView)
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
    
    // MARK: - Constraints
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        return 20
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
        return cell
    }
    
    /// Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewHeader.identifier) as? FFProductTableViewHeader else {
            return UIView()
        }
        view.priceButton.addTarget(self, action: #selector(priceSortDidTap), for: .touchUpInside)
        view.categoryButton.addTarget(self, action: #selector(categorySortDidTap(sender: )), for: .touchUpInside)
        view.categoryButton.sendActions(for: .touchUpInside)
        view.stockButton.addTarget(self, action: #selector(stockSortDidTap), for: .touchUpInside)
        view.supplierButton.addTarget(self, action: #selector(supplierSortDidTap), for: .touchUpInside)
        view.layer.cornerRadius = 0
        return view
    }
    
    /// Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
}