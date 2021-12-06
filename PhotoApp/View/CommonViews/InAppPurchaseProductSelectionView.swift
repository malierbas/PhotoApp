//
//  InAppPurchaseProductSelectionView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class InAppPurchaseProductSelectionView: UIView {

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#494949")
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()

    private let selectionCircleView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(hex: "#BEBEBE").cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .clear
        return view
    }()

    let discountBadgeView: ProductDiscountBadgeView = {
        let discountBadgeView = ProductDiscountBadgeView()
        return discountBadgeView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textColor = UIColor(hex: "#FFE35C")
        label.isHidden = true
        return label
    }()

    private let titleSubtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()

    let originalPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var subtitle: String? {
        didSet {
            guard let subtitle = subtitle else { return }
            subtitleLabel.isHidden = false
            subtitleLabel.text = subtitle
        }
    }

    var discountPercent: String? {
        didSet {
            guard let discountPercent = discountPercent else { return }
            discountBadgeView.titleLabel.text = "\(discountPercent)%\nOFF"
        }
    }

    var originalPriceText: String? {
        didSet {
            guard let originalPriceText = originalPriceText else { return }

            let attributedString = NSMutableAttributedString(string: originalPriceText as String, attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                .foregroundColor: UIColor(hex: "#F93B42"),
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ])
            originalPriceLabel.attributedText = attributedString

        }
    }

    var isSelected: Bool? {
        didSet {
            guard let isSelected = isSelected else { return }
            selectionCircleView.layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor(hex: "#BEBEBE").cgColor
            selectionCircleView.layer.borderWidth = isSelected ? 2 : 1
            selectionCircleView.backgroundColor = isSelected ? UIColor(hex: "#FFD300") : .clear
            contentView.layer.borderColor = isSelected ? UIColor(hex: "#FFD300").cgColor : UIColor.clear.cgColor
            contentView.layer.borderWidth = isSelected ? 1 : 0
        }
    }

    var selectionCircleHeight: CGFloat = 24

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

    private func prepareUI() {
        addSubview(contentView)
        addSubview(discountBadgeView)
        contentView.addSubview(selectionCircleView)

        contentView.addSubview(titleSubtitleStackView)

        titleSubtitleStackView.addArrangedSubview(titleLabel)
        titleSubtitleStackView.addArrangedSubview(subtitleLabel)

        contentView.addSubview(originalPriceLabel)

        selectionCircleView.layer.cornerRadius = selectionCircleHeight / 2.0

        setupLayout()
    }

    private func setupLayout() {
        contentView.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           trailing: trailingAnchor,
                           bottom: bottomAnchor,
                           padding: .init(topPadding: 10))

        discountBadgeView.anchor(top: topAnchor, trailing: trailingAnchor)
        discountBadgeView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        discountBadgeView.widthAnchor.constraint(equalToConstant: 48).isActive = true

        selectionCircleView.anchor(leading: leadingAnchor, padding: .init(leftPadding: 20))
        selectionCircleView.anchorCenterYToSuperview()
        selectionCircleView.widthAnchor.constraint(equalToConstant: selectionCircleHeight).isActive = true
        selectionCircleView.heightAnchor.constraint(equalTo: selectionCircleView.widthAnchor).isActive = true

        titleSubtitleStackView.anchor(leading: selectionCircleView.trailingAnchor, padding: .init(leftPadding: 16))
        titleSubtitleStackView.anchorCenterYToSuperview()

        originalPriceLabel.anchor(leading: titleSubtitleStackView.trailingAnchor, padding: .init(leftPadding: 12))
        originalPriceLabel.trailingAnchor.constraint(lessThanOrEqualTo: discountBadgeView.leadingAnchor, constant: -8).isActive = true
        originalPriceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    }
}
