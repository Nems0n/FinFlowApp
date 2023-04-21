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
    /// Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    /// Cell for index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FFProductTableViewCell.identifier, for: indexPath) as? FFProductTableViewCell else {
            let cell = UITableViewCell()
            cell.backgroundColor = .white
            return cell
        }
        
        guard self.dataArray.indices.contains(indexPath.row), let cellVM = self.dataArray[indexPath.row] else {
            let cell = UITableViewCell()
            cell.isUserInteractionEnabled = false
            return cell
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = .appColor(.systemAccentOne)?.withAlphaComponent(0.05)
        cell.selectedBackgroundView = backgroundView
        cell.setupCell(viewModel: cellVM)
        
        return cell
    }
    /// Header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewHeader.identifier) as? FFProductTableViewHeader else {
            return UIView()
        }
        view.priceButton.addTarget(self, action: #selector(priceSortDidTap), for: .touchUpInside)
        view.categoryButton.addTarget(self, action: #selector(categorySortDidTap(sender: )), for: .touchUpInside)
        view.categoryButton.sendActions(for: .touchUpInside)
        view.stockButton.addTarget(self, action: #selector(stockSortDidTap), for: .touchUpInside)
        view.supplierButton.addTarget(self, action: #selector(supplierSortDidTap), for: .touchUpInside)
        return view
    }
    /// Footer view
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FFProductTableViewFooterV.identifier) as? FFProductTableViewFooterV else {
            return UIView()
        }
        return view
    }
    /// Header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
    /// Footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    /// Did select cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.dataArray.indices.contains(indexPath.row), let cellVM = self.dataArray[indexPath.row] else { return }
        let detailVM = FFStorageCellDetailVM(product: cellVM.product)
        viewModel?.cellDidTap(with: detailVM)
    }
    
}
