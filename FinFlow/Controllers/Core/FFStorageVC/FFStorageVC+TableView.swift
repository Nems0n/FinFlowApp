//
//  FFStorageVC+TableView.swift
//  FinFlow
//
//  Created by Vlad Todorov on 12.03.23.
//

import Foundation
import UIKit

//MARK: - Extension for TableView
extension FFStorageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FFProductTableViewCell.identifier, for: indexPath) as? FFProductTableViewCell else {
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            return cell
        }
        guard self.dataArray.indices.contains(indexPath.row), let cellVMM = self.dataArray[indexPath.row] else { return UITableViewCell() }
        cell.setupCell(viewModel: cellVMM)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewHeader.identifier) as? FFProductTableViewHeader else {
            return UIView()
        }
        view.priceButton.addTarget(self, action: #selector(priceTouched), for: .touchUpInside)

        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewFooterV.identifier) as? FFProductTableViewFooterV else {
            return UIView()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }

}
