//
//  FFStorageSearchResultViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.02.23.
//

import UIKit

class FFStorageSearchResultVC: UIViewController {
    // MARK: - UI Elements
    
    private var viewModel: FFStorageVM
    
    private var searchArray = [Product]() {
        didSet {
            self.searchGoodsTableView.reloadData()
        }
    }

    lazy var searchGoodsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "goodsSearch")
        table.clipsToBounds = true
        table.isScrollEnabled = true
        table.backgroundColor = .white
        return table
    }()
    
    // MARK: - Lifecycle
    init(viewModel: FFStorageVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        addSubviews()
        setupBindings()
        configureLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchArray.removeAll()
    }

    // MARK: - Setup view
    private func addSubviews() {
        view.addSubview(searchGoodsTableView)
    }
    
    private func setupElements() {
        searchGoodsTableView.delegate = self
        searchGoodsTableView.dataSource = self
        
    }
    // MARK: - Methods
    
    private func setupBindings() {
        viewModel.searchDataSource.bind { [weak self] array in
            self?.searchArray = array
        }
    }
    
    
    // MARK: - Constraints
    private func configureLayout() {
        NSLayoutConstraint.activate([
            searchGoodsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchGoodsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchGoodsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchGoodsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

// MARK: - TableView Delegate & DataSource
extension FFStorageSearchResultVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goodsSearch", for: indexPath) as UITableViewCell

        var conf = UIListContentConfiguration.cell()
        conf.text = searchArray[indexPath.row].productName
        cell.contentConfiguration = conf
        let backgroundView = UIView()
        backgroundView.backgroundColor = .appColor(.systemAccentOne)?.withAlphaComponent(0.05)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = searchArray[indexPath.row]
        let vm = FFStorageCellDetailVM(product: product)
        viewModel.cellDidTap(with: vm)
        tableView.deselectRow(at: indexPath, animated: true)
        searchArray.removeAll()
    }
    
    
}
