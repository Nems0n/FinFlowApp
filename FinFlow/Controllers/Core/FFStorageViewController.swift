//
//  FFStorageViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import UIKit

final class FFStorageViewController: UIViewController {
    
    var mainView = FFStorageMainView()
    
    //MARK: - VC Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = mainView.searchController
        view.backgroundColor = .white
        mainView.delegate = self
        navigationItem.searchController?.delegate = self
        navigationItem.searchController?.searchResultsUpdater = self
        addSubviews()
        createConstraints()
    }
    
    //MARK: - Setup view
    private func addSubviews() {
        view.addSubview(mainView)
    }
   
    //MARK: - Add constraints
    private func createConstraints() {
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -50),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Extensions
extension FFStorageViewController: FFStorageMainViewDelegate {
    func searchBarTouched() {
        navigationController?.navigationBar.isHidden = false
        DispatchQueue.main.async {
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
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
