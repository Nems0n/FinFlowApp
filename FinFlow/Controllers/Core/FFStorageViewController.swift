//
//  FFStorageViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import UIKit

final class FFStorageViewController: UIViewController {

    let searchController: UISearchController = {
        let resultVC = FFStorageSearchResultViewController()
        let sc = UISearchController(searchResultsController: resultVC)
        return sc
    }()
    
    var mainView = FFStorageMainView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        view.backgroundColor = .white
        mainView.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        addSubviews()
        createConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(mainView)
    }
   
    private func createConstraints() {
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -50),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension FFStorageViewController: FFStorageMainViewDelegate {
    func searchBarTouched() {
        navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
}

extension FFStorageViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
