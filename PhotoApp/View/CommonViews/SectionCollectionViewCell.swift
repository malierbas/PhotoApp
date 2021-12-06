//
//  SectionCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class SectionCollectionViewCell: UICollectionViewCell {

    let titleLabel: LabelWithPadding = {
        let label = LabelWithPadding()
        label.padding = UIEdgeInsets(topPadding: 6, leftPadding: 20, bottomPadding: 6, rightPadding: 20)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()

    override var isSelected: Bool {
        didSet {
            handleSelection()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = titleLabel.frame.height / 2.0
        clipsToBounds = true
    }

    private func prepareUI() {
        addSubview(titleLabel)
        setupLayout()
    }

    private func setupLayout() {
        titleLabel.fillSuperview()
    }

    private func handleSelection() {
        titleLabel.textColor = isSelected ? .white : .black
        titleLabel.backgroundColor = isSelected ? UIColor(hexString: "#1C1F21") : .white
        layer.borderColor = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
        layer.borderWidth = isSelected ? 0.5 : 0
    }
}
