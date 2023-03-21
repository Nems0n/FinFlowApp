//
//  FFStorageCellDetailViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 14.03.23.
//

import UIKit

class FFStorageCellDetailVC: UIViewController {

//    var coordinator: Coordinator?
    
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .appColor(.systemBorder)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Hello"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.addSubview(bgView)
        
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            bgView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            bgView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    

}
