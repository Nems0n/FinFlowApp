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
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "finFlowInnerLogo")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .poppins(.regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let emailTF: UITextField = {
        let tf = AppTextField()
        return tf
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .poppins(.regular, size: 14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private let passwordTF: UITextField = {
        let tf = AppTextField(tag: 1, isSecure: true)
        return tf
    }()
    
    private let loginButton: AppGradientButton = {
        let button = AppGradientButton(isGradient: false,
                                       title: "Log in",
                                       nil,
                                       bgColor: .appColor(.systemAccentThree)?.withAlphaComponent(0.2),
                                       highlight: .appColor(.systemAccentThree)?.withAlphaComponent(0.5),
                                       borderColor: .appColor(.systemAccentOne)?.withAlphaComponent(0.7))

        button.setTitleColor(.appColor(.systemBG)?.withAlphaComponent(0.6), for: .normal)
        button.titleLabel?.font = .poppins(.medium, size: 12)
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        
        createConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: - Injection
    public func setVM(viewModel: FFLoginVM) {
        self.viewModel = viewModel
    }
    
    //MARK: - Setup view
    private func setupElements() {
        view.backgroundColor = .systemBackground
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        emailTF.delegate = self
        passwordTF.delegate = self
        dismissKeyboard()
        setupBindings()
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(emailLabel)
        view.addSubview(emailTF)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (view.frame.height * 0.06)),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emailLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7, constant: -16),
            emailLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            emailLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -((16 + 36))),
            
            emailTF.widthAnchor.constraint(equalTo: emailLabel.widthAnchor, constant: 16),
            emailTF.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTF.heightAnchor.constraint(equalToConstant: 36),
            emailTF.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4),
            
            passwordLabel.widthAnchor.constraint(equalTo: emailLabel.widthAnchor),
            passwordLabel.centerXAnchor.constraint(equalTo: emailLabel.centerXAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 16),
//            passwordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: (16 + 36)/2),
            
            passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor),
            passwordTF.heightAnchor.constraint(equalTo: emailTF.heightAnchor),
            passwordTF.centerXAnchor.constraint(equalTo: passwordLabel.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 4),
            
            loginButton.widthAnchor.constraint(equalTo: logoImageView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 36),
            loginButton.centerXAnchor.constraint(equalTo: passwordTF.centerXAnchor),
//            loginButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 32)
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: (view.frame.height * -0.06))
        ])
    }
    
    //MARK: - Methods
    private func setupBindings() {
        viewModel?.isActivityIndicator.bind({ [weak self] show in
            guard let show = show else { return }
            switch show {
            case true:
                guard let self = self else { return }
                DispatchQueue.main.async {
                    FFActivityIndicatorManager.shared.showActivityIndicator(on: self.view)
                }
            case false:
                FFActivityIndicatorManager.shared.stopActivityIndicator()
            }
        })
        
        viewModel?.isRequestFailed.bind({ [weak self] showAlert in
            print("show failed request")
            guard let self = self else { return }
            if showAlert {
                FFAlertManager.showInvalidLoginAlert(on: self)
            }
        })
        
        viewModel?.isConnectionLost.bind({ [weak self] lost in
            print("show connection lost")
            guard let self = self else { return }
            if lost {
                FFAlertManager.showLostConnectionAlert(on: self)
            }
        })
    }
    
    //MARK: - Selectors
    @objc private func loginButtonDidTap() {
        viewModel?.email = emailTF.text
        viewModel?.password = passwordTF.text
        Task {
            await viewModel?.loginButtonAction()
        }
    }


}

extension FFLoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
           nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonDidTap()
        }
        return true
    }
}
