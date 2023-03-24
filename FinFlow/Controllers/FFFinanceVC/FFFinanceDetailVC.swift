//
//  FFFinanceDetailVC.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.03.23.
//

import UIKit

class FFFinanceDetailVC: UIViewController {
    
    var coordinator: FFFinanceCoordinator?
    
    private let mainButton: UIButton = {
        let button = UIButton()
        button.configuration = .tinted()
        button.setTitle("I want more", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainButton.addTarget(self, action: #selector(mainTap), for: .touchUpInside)
        view.addSubview(mainButton)
        title = "Detail"
        view.backgroundColor = .white
        
        
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            mainButton.widthAnchor.constraint(equalToConstant: 150),
            mainButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func mainTap() {
        let vc = UIViewController()
        vc.title = "DetailOfDetail"
        vc.view.backgroundColor = .white
        coordinator?.trigger(.detailOfDetail(vc))
    }

}
