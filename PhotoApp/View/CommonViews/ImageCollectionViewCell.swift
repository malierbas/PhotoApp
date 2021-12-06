//
//  ImageCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let freeBadgeView: FreeBadgeView = {
        let badgeView = FreeBadgeView()
        badgeView.isHidden = true
        return badgeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        layer.shadowOpacity = 0.35
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.lightGray.cgColor
        addSubview(imageView)
        addSubview(freeBadgeView)
        setupLayout()
    }
    
    private func setupLayout() {
        imageView.fillSuperview()

        freeBadgeView.anchor(trailing: trailingAnchor, bottom: bottomAnchor)
        freeBadgeView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        freeBadgeView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        freeBadgeView.isHidden = true
    }
}

