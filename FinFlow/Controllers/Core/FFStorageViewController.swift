//
//  FFStorageViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import UIKit

final class FFStorageViewController: UIViewController {

    let searchController = UISearchController()
    
    var mainView = FFStorageMainView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainView.delegate = self
        addSubviews()
        createConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
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
        let resultVC = FFStorageSearchViewController()
        navigationController?.pushViewController(resultVC, animated: false)
    }
    
}
