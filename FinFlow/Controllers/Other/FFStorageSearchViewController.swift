//
//  FFStorageResultViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import UIKit

class FFStorageSearchViewController: UIViewController {

    let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.setShowsCancelButton(true, animated: true)
        return controller
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        searchController.searchBar.delegate = self
        view.backgroundColor = .lightText
        navigationItem.searchController = searchController
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
}

extension FFStorageSearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popToRootViewController(animated: false)
    }
    
}
