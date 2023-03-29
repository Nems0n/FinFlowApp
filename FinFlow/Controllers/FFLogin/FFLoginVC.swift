//
//  FFLoginVC.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.03.23.
//

import UIKit

class FFLoginVC: UIViewController {
    
    //MARK: - UI Elements
    var viewModel: FFLoginVM?
    
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your email"
        tf.textColor = .black
        tf.font = .poppins(.regular, size: 14)
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.textColor = .black
        tf.font = .poppins(.regular, size: 14)
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(configuration: .borderedTinted())
        button.setTitle("Log in", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
        
        createConstraints()
    }
    
    //MARK: - Injection
    public func setVM(viewModel: FFLoginVM) {
        self.viewModel = viewModel
    }
    
    //MARK: - Setup view
    private func setupElements() {
        view.backgroundColor = .systemBackground
        
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            emailTF.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            emailTF.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTF.heightAnchor.constraint(equalToConstant: 32),
            emailTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            
            passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor),
            passwordTF.heightAnchor.constraint(equalTo: emailTF.heightAnchor),
            passwordTF.centerXAnchor.constraint(equalTo: emailTF.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 24),
            
            loginButton.widthAnchor.constraint(equalTo: passwordTF.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            loginButton.centerXAnchor.constraint(equalTo: passwordTF.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 32)
        ])
    }
    
    //MARK: - Selectors
    @objc private func loginButtonDidTap() {
        viewModel?.email = emailTF.text
        viewModel?.password = passwordTF.text
        viewModel?.loginButtonAction()
    }


}
