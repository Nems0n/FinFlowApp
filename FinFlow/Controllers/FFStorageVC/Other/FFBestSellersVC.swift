//
//  FFBestSellersVC.swift
//  FinFlow
//
//  Created by User Account on 26/05/2023.
//

import UIKit

class FFBestSellersVC: UIViewController {
    
    // MARK: - Variables
    private let viewModel: FFBestSellersVM
    
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

    private var tableRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        control.tintColor = .appColor(.systemBG)?.withAlphaComponent(0.8)
        control.backgroundColor = .white
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
//        view.refreshControl = tableRefreshControl
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var dataSource = [FFProductCellVM?]() {
        didSet {
            self.mainTableView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    init(viewModel: FFBestSellersVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupNavBar()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let defaultAppearance = UINavigationBarAppearance()
        defaultAppearance.backgroundColor = .white
        defaultAppearance.shadowColor = .clear
        self.navigationController?.navigationBar.scrollEdgeAppearance = defaultAppearance
        self.navigationController?.navigationBar.standardAppearance = defaultAppearance
    }
    
    // MARK: - Methods
    private func setupView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.appColor(.systemBG) ?? .black, renderingMode: .alwaysOriginal),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(backButtonDidTap))
        title = "Best Sellers"
        view.backgroundColor = .white
        mainTableView.delegate = self
        mainTableView.dataSource = self
        navBarLayer.frame = CGRect(x: 0, y: 0, width: navigationController?.navigationBar.bounds.width ?? 0, height: navigationController?.navigationBar.bounds.height ?? 0)
        let bgImage = getImageFrom(gradientLayer: navBarLayer)
        imageForNavBar = bgImage
    }
    
    private func addSubviews() {
        view.addSubview(mainTableView)
    }
    
    private func setupNavBar() {
        navBarAppearance.backgroundImage = imageForNavBar
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.standardAppearance = self.navigationController?.navigationBar.scrollEdgeAppearance ?? navBarAppearance
    }
    
    private func setupBindings() {
        viewModel.cellDataSource.bind { dataSource in
            self.dataSource = dataSource
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

    // MARK: - Selectors
    @objc private func backButtonDidTap() {
        viewModel.popViewController()
    }
    
    // MARK: - Constraints
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension FFBestSellersVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FFProductTableViewCell.identifier, for: indexPath) as? FFProductTableViewCell else {
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            return cell
        }
        guard self.dataSource.indices.contains(indexPath.row), let cellVM = self.dataSource[indexPath.row] else {
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            return cell
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = .appColor(.systemAccentOne)?.withAlphaComponent(0.05)
        cell.selectedBackgroundView = backgroundView
        cell.setupCell(viewModel: cellVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.dataSource.indices.contains(indexPath.row), let cellVM = self.dataSource[indexPath.row] else { return }
        let detailVM = FFStorageCellDetailVM(product: cellVM.product)
        viewModel.cellDidTap(with: detailVM)
    }
    
}
