//
//  ColorCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {

    private let colorImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .purple
        view.clipsToBounds = true
        return view
    }()

    var color: UIColor? {
        didSet {
            guard let color = color else { return }
            colorImageView.backgroundColor = color

            if color == .white || color == .clear {
                colorImageView.layer.borderColor = UIColor.darkGray.cgColor
                colorImageView.layer.borderWidth = 1
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
            layer.borderWidth = isSelected ? 2 : 0
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
        colorImageView.layer.cornerRadius = colorImageView.frame.height / 2.0
        layer.cornerRadius = frame.height / 2.0
    }

    private func prepareUI() {
        backgroundColor = .white
        addSubview(colorImageView)
        setupLayout()
    }

    private func setupLayout() {
        colorImageView.fillSuperview(withPadding: .init(topPadding: 4, leftPadding: 4, bottomPadding: 4, rightPadding: 4))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0

        colorImageView.layer.borderColor = UIColor.clear.cgColor
        colorImageView.layer.borderWidth = 0
    }
}
