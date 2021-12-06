//
//  StickerCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let premiumBadgeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "premium-crown"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()

    var sticker: Sticker? {
        didSet {
            backgroundImageView.image = sticker?.image
            if let isFree = sticker?.isFree, !isFree && !LocalStorageManager.shared.isPremiumUser {
                premiumBadgeImageView.isHidden = false
            }
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
        addSubview(backgroundImageView)
        addSubview(premiumBadgeImageView)
        setupLayout()
    }

    private func setupLayout() {
        backgroundImageView.fillSuperview(withPadding: .init(topPadding: 2, leftPadding: 2, bottomPadding: 2, rightPadding: 2))

        premiumBadgeImageView.anchor(top: topAnchor,
                                     trailing: trailingAnchor,
                                     padding: .init(topPadding: -4, rightPadding: -4))
        premiumBadgeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        premiumBadgeImageView.heightAnchor.constraint(equalTo: premiumBadgeImageView.widthAnchor).isActive = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        premiumBadgeImageView.isHidden = true
    }
}

