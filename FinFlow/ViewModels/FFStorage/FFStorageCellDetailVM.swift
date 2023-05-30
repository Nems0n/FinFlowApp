//
//  FFStorageCellDetailVM.swift
//  FinFlow
//
//  Created by Vlad Todorov on 24.03.23.
//

import Foundation
import UIKit

class FFStorageCellDetailVM: NSObject {
    
    var coordinator: FFStorageCoordinator?
    
    public var isShowSuccess: Binder<Bool?> = Binder(nil)
    
    var id: Int
    var name: String
    var price: Float
    var amount: Int
    var category: Category
    var supplier: String?
    
    //MARK: - Init
    init(product: Product) {
        self.id = product.id
        self.name = product.productName
        self.price = product.price
        self.amount = product.amount
        self.category = product.category
        self.supplier = product.supplier
    }
    
    //MARK: - Methods
    public func setCoordinator(coordinator: FFStorageCoordinator) {
        self.coordinator = coordinator
    }
    
    public func backButtonDidTap() {
        coordinator?.trigger(.pop)
    }
    
    public func deleteProduct() async {
        let product = ProductToDelete(id: id)
        let request = FFRequest(endpoint: .deleteProduct, httpMethod: .delete, httpBody: product)
        do {
            try await FFService.shared.execute(request)
            isShowSuccess.value = true
        } catch(let error) {
            print(error)
            isShowSuccess.value = false
        }
    }
}
