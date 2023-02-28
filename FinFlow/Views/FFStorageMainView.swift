//
//  FFStorageMainView.swift
//  FinFlow
//
//  Created by Vlad Todorov on 24.02.23.
//

import Foundation
import UIKit

protocol FFStorageMainViewDelegate: AnyObject {
    func searchBarTouched()
}

final class FFStorageMainView: UIView {
    
    public weak var delegate: FFStorageMainViewDelegate?
    
    private let viewModel = FFStorageMainViewModel()
    
    let searchController: UISearchController = {
        let resultVC = FFStorageSearchResultViewController()
        let sc = UISearchController(searchResultsController: resultVC)
        return sc
    }()

    let searchTextField: UITextField = {
        let tf = UITextField()
        let imageContainer =  UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        imageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(white: 0, alpha: 0.2)
        imageView.contentMode = .scaleAspectFit
        imageContainer.addSubview(imageView)
        tf.leftViewMode = .always
        tf.leftView = imageContainer
        tf.textColor = UIColor(white: 0, alpha: 0.2)
        tf.placeholder = "Start typing..."
        tf.font = .poppins(.regular, size: 14)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isContextMenuInteractionEnabled = false
        return tf
    }()
    
    let underlineBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userButton: UIButton = {
        let button = UIButton()
        if let image = UIImage(named: "testAvatar") {
            button.setImage(image, for: .normal)
        }
        button.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchTextField.delegate = viewModel
        viewModel.delegate = self
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        createConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        searchTextField.addSubview(underlineBorder)
        addSubview(searchTextField)
        addSubview(userButton)
    }
    
    private func createConstraints() {

        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            searchTextField.topAnchor.constraint(equalTo: topAnchor)
        ])
        NSLayoutConstraint.activate([
            underlineBorder.heightAnchor.constraint(equalToConstant: 1),
            underlineBorder.widthAnchor.constraint(equalTo: searchTextField.widthAnchor),
            underlineBorder.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: -1),
            underlineBorder.leftAnchor.constraint(equalTo: searchTextField.leftAnchor)
        ])
        NSLayoutConstraint.activate([
            userButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            userButton.topAnchor.constraint(equalTo: topAnchor),
            userButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
            userButton.widthAnchor.constraint(equalTo: searchTextField.heightAnchor)
        ])
    }
}



extension FFStorageMainView: FFStorageMainViewModelDelegate {
    func didTapSearhBar() {
        delegate?.searchBarTouched()
        DispatchQueue.main.async {
            self.searchTextField.resignFirstResponder()
        }
    }

}