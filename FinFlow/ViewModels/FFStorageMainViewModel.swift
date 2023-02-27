//
//  FFStorageMainViewModel.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import Foundation
import UIKit

protocol FFStorageMainViewModelDelegate: AnyObject {
    func didTapSearhBar()
    
}

final class FFStorageMainViewModel: NSObject {
    public weak var delegate: FFStorageMainViewModelDelegate?
}

extension FFStorageMainViewModel: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.didTapSearhBar()
        return true
    }
    
}
