//
//  FFGoodsTableViewCell.swift
//  FinFlow
//
//  Created by Vlad Todorov on 2.03.23.
//

import UIKit

class FFProductTableViewCell: UITableViewCell {
    //MARK: - Variables
    
    var coordinator: FFStorageCoordinator?
    
    public static var identifier: String {
        get {
            return String(describing: self)
        }
    }
    lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .poppins(.regular, size: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var currency: String = "UAH"
    var priceString: String?
    var finalPriceString: String?
    
    lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .poppins(.regular, size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let image = UIImage(systemName: "chevron.forward")?.withTintColor(.appColor(.systemAccentOne)?.withAlphaComponent(0.3) ?? .gray, renderingMode: .alwaysOriginal)
        let view = UIImageView(frame: .zero)
        view.image = image
        view.contentMode = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        separatorInset = UIEdgeInsets.zero
        createConstraints()
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productTitleLabel.text = nil
        productPriceLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Methods
    public func setupCell(viewModel: FFProductCellVM) {
        self.backgroundColor = .white
        self.productTitleLabel.text = viewModel.name
        self.priceString = String(viewModel.price)
        guard priceString != nil else { return }
        finalPriceString = priceString! + " " + currency
        createPriceString()
    }
    
    private func addSubviews() {
        addSubview(productTitleLabel)
        addSubview(productPriceLabel)
        addSubview(iconImageView)
    }
    
    private func createPriceString() {
        let attributedText = NSMutableAttributedString(string: finalPriceString ?? "")
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], range: getRangeOfSubString(subString: priceString ?? "", fromString: finalPriceString ?? ""))
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: getRangeOfSubString(subString: currency, fromString: finalPriceString ?? ""))
        productPriceLabel.attributedText = attributedText
    }
    
    private func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
        let sampleLinkRange = fromString.range(of: subString)!
        let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
        let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
        let linkRange = NSMakeRange(startPos, endPos - startPos)
        return linkRange
    }
    //MARK: - Add constraints
    private func createConstraints() {
        productPriceLabel.sizeToFit()
        NSLayoutConstraint.activate([
            productTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            productTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
//            productPriceLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            productPriceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            productPriceLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -8),
        ])
    }
    
}
