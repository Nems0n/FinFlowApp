//
//  FFAddProductVM.swift
//  FinFlow
//
//  Created by User Account on 16/05/2023.
//

import Foundation

final class FFAddProductVM {
    
    // MARK: - Variables
    var coordinator: FFStorageCoordinator
    
    public var isWrongDataEntered = Binder(false)
    public var isProductAdded = Binder(false)
    
    // MARK: - Init
    init(coordinator: FFStorageCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    public func addNewProduct(name: String, category: String, price: String, amount: String, supplier: String) async {
        guard let categ = Category(rawValue: category), let price = Float(price), let amount = Int(amount) else {
            isWrongDataEntered.value = true
            return }
        let product = ProductPost(name: name, category: categ, price: price, amount: amount, supplier: supplier)
        let request = FFRequest(endpoint: .addProduct, httpMethod: .post, httpBody: product)
        
        do {
            try await FFService.shared.execute(request)
            isProductAdded.value = true
        } catch(let error) {
            print("NOT ADDED")
            print(error.localizedDescription)
        }
    }
    
    public func popViewController() {
        coordinator.trigger(.dismiss)
    }
}
