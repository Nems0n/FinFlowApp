//
//  FFMainViewCardView.swift
//  FinFlow
//
//  Created by Vlad Todorov on 28.02.23.
//

import UIKit

class FFMainViewCardView: UIView {

    //MARK: - UI Objects
    let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Total amount of goods in stock"
        label.font = .poppins(.bold, size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var amountLabel: UILabel = {
        var label = UILabel()
        label.text = String(52264)
        label.font = .poppins(.regular, size: 22)
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    private var bgColorsArray: [CGColor] = {
        var array = [CGColor]()
        array.append(UIColor.appColor(.systemGradientPurple)?.cgColor ?? CGColor(gray: 1, alpha: 1))
        array.append(UIColor.appColor(.systemGradientBlue)?.cgColor ?? CGColor(gray: 1, alpha: 1))
        return array
    }()
    
    public var dateLabel: UILabel = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd YYYY HH:mm"
        let date = Date()
        var label = UILabel()
        label.text = dateFormatter.string(from: date)
        label.font = .poppins(.regular, size: 11)
        label.textColor = .appColor(.systemBG)?.withAlphaComponent(0.5)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - UIView Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelf()
        setupSubviews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient(colors: bgColorsArray, angle: 60)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Funcs to setup UI
    private func setupSelf() {
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.appColor(.systemBorder)?.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    private func setupSubviews(){
        addSubview(mainTitle)
        addSubview(amountLabel)
        addSubview(dateLabel)
    }
    
    //MARK: - Add constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainTitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            mainTitle.heightAnchor.constraint(equalToConstant: 24),
            mainTitle.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            amountLabel.leadingAnchor.constraint(equalTo: mainTitle.leadingAnchor),
            amountLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        ])
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 150),
            dateLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
}
 
