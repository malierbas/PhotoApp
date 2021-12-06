//
//  ProductDiscountBadgeView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class ProductDiscountBadgeView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .white
        label.text = "62%\nOFF"
        return label
    }()

    init() {
        super.init(frame: .zero)
        prepareUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(with: [UIColor(hex: "#FFDA39"), UIColor(hex: "#FF6600")], gradient: .horizontal)
    }

    private func prepareUI() {
        layer.cornerRadius = 4
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        clipsToBounds = true
        addSubview(titleLabel)
        setupLayout()
    }

    private func setupLayout() {
        titleLabel.fillSuperview()
    }

}
