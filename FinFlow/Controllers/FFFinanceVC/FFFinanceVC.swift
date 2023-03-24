//
//  FFFinanceViewController.swift
//  FinFlow
//
//  Created by Vlad Todorov on 21.02.23.
//

import UIKit

final class FFFinanceVC: UIViewController {
    var coordinator: FFFinanceCoordinator?
    
    let mainButton: UIButton = {
        let button = UIButton(configuration: .tinted())
        button.setTitle("Fuck tap me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Finance"
        mainButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside
        )
        
        view.addSubview(mainButton)
        
        addConstraints()
    }

    
    @objc func nextVC() {
        let newVC = FFFinanceDetailVC()
        newVC.coordinator = coordinator
        coordinator?.trigger(.detail(newVC))
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mainButton.widthAnchor.constraint(equalToConstant: 150),
            mainButton.heightAnchor.constraint(equalToConstant: 30),
            mainButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

}
