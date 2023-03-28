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
    
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Injection
    public func setVM(viewModel: FFLoginVM) {
        self.viewModel = viewModel
    }
    
    //MARK: - Setup view
    private func addSubviews() {
        
    }


}
