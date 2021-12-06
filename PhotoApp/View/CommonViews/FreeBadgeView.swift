//
//  FreeBadgeView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class FreeBadgeView: UIView {

    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.text = "Free"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.maskedCorners = [.layerMinXMinYCorner]
        layer.cornerRadius = 4

        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.lightGray.cgColor

    }

    private func prepareUI() {
        backgroundColor = .white
        addSubview(badgeLabel)
        setupLayout()
    }

    private func setupLayout() {
        badgeLabel.fillSuperview()
    }

}

