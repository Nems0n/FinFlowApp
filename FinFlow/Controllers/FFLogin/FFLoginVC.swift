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
    
    private let emailTF: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Enter your email"
        tf.textColor = .black
        tf.font = .poppins(.regular, size: 14)
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.tag = 0
        return tf
    }()
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.textColor = .black
        tf.font = .poppins(.regular, size: 14)
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.tag = 1
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
//    private let loginButton: UIButton = {
//        let button = UIButton(configuration: .borderedTinted())
//        button.setTitle("Log in", for: .normal)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let loginButton: AppGradientButton = {
        let button = AppGradientButton(isGradient: false,
                                       title: "Log in",
                                       nil,
                                       bgColor: .appColor(.systemAccentThree)?.withAlphaComponent(0.2),
                                       highlight: .appColor(.systemAccentThree)?.withAlphaComponent(0.5),
                                       borderColor: .appColor(.systemAccentOne)?.withAlphaComponent(0.7))

        button.setTitleColor(.appColor(.systemBG)?.withAlphaComponent(0.6), for: .normal)
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
        view.addSubview(emailTF)
        view.addSubview(passwordTF)
        view.addSubview(loginButton)
    }
    
    private func createConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (view.frame.height * 0.06)),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            emailTF.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            emailTF.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emailTF.heightAnchor.constraint(equalToConstant: 32),
            emailTF.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            
            passwordTF.widthAnchor.constraint(equalTo: emailTF.widthAnchor),
            passwordTF.heightAnchor.constraint(equalTo: emailTF.heightAnchor),
            passwordTF.centerXAnchor.constraint(equalTo: emailTF.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 24),
            
            loginButton.widthAnchor.constraint(equalTo: logoImageView.widthAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 36),
            loginButton.centerXAnchor.constraint(equalTo: passwordTF.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 32)
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
