//
//  FFStorageMainViewModel.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import Foundation
import UIKit

protocol FFStorageMainVMDelegate: AnyObject {
    func didTapSearhBar() 
}

final class FFStorageMainVM: NSObject {
    public weak var delegate: FFStorageMainVMDelegate?
    public var userAvatarAction = UIAction { _ in
        print("button touched")
    }
}

extension FFStorageMainVM: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: - SearchBar
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.didTapSearhBar()
        return true
    }
    //MARK: - TableViewProtocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }

    
}


