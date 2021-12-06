//
//  FontCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class FontCollectionViewCell: UICollectionViewCell {

    private lazy var fontLabel: UILabel = {
        let label = UILabel()
        label.text = font?.fontName
        label.font = font
        label.textColor = .black
        return label
    }()

    var font: UIFont? {
        didSet {
            fontLabel.text = font?.familyName
            fontLabel.font = font
        }
    }

    override var isSelected: Bool {
        didSet {
            fontLabel.alpha = isSelected ? 1 : 0.3
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareUI() {
        fontLabel.alpha = 0.3
        addSubview(fontLabel)
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    private func setupLayout() {
        fontLabel.fillSuperview()
    }
}
