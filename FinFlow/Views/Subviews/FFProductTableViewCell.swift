//
//  FFGoodsTableViewCell.swift
//  FinFlow
//
//  Created by Vlad Todorov on 2.03.23.
//

import UIKit

class FFProductTableViewCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return String(describing: self)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupCell(viewModel: FFProductCellVM) {
        self.backgroundColor = viewModel.backgroundColor
    }
}
