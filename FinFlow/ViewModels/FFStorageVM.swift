//
//  FFStorageMainViewModel.swift
//  FinFlow
//
//  Created by Vlad Todorov on 26.02.23.
//

import Foundation
import UIKit

final class FFStorageVM: NSObject {
    public var userAvatarAction = UIAction { _ in
        print("button touched")
    }
    
    var buttonHasPressed: Binder<Bool> = Binder(false)
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
    
    var dataSource: [Product] = {
        var array = [Product]()
        let product1 = Product(id: 235, productName: "Bread", price: 2.0, amount: 5, backgroundColor: .blue.withAlphaComponent(0.2))
        let product2 = Product(id: 2564, productName: "Apple", price: 1.8, amount: 25, backgroundColor: .green.withAlphaComponent(0.2))
        array.append(product1)
        array.append(product2)
        return array
    }()
    
    func mapCellData() {
        self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
    
     func userAvatarTouched() {
         self.buttonHasPressed = Binder(true)
    }
    
    func addNewProduct() {
        let newProduct = Product(id: 2345, productName: "34256", price: 235, amount: 2345, backgroundColor: .black.withAlphaComponent(0.15))
        self.dataSource.append(newProduct)
//        mapCellData()
    }
}

/*extension FFStorageMainVM: UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: - TableViewProtocols
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        mapCellData()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FFProductTableViewCell.identifier, for: indexPath) as? FFProductTableViewCell else {
            return UITableViewCell()
        }
        guard let cellVM = cellDataSource?[indexPath.row] else {
            return UITableViewCell()
        }
        print(cellVM)
        cell.setupCell(viewModel: cellVM)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewHeader.identifier)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }


}


*/
