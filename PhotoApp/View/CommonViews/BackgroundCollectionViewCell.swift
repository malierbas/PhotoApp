//
//  BackgroundCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {

    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .purple
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.9).cgColor
        view.layer.borderWidth = 2
        return view
    }()

    private lazy var gradientLayerView: GradientLayerView = {
        let gradientLayerView = GradientLayerView()
        gradientLayerView.clipsToBounds = true
        gradientLayerView.isHidden = true
        return gradientLayerView
    }()

    private let premiumBadgeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "premium-crown"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var background: Background? {
        didSet {
            guard let background = background else { return }
            backgroundImageView.backgroundColor = background.color
            backgroundImageView.image = background.preview
            premiumBadgeImageView.isHidden = background.isFree || LocalStorageManager.shared.isPremiumUser
            if let gradientLayerView = background.gradientLayerView {
                self.gradientLayerView.isHidden = false
                self.gradientLayerView.colors = gradientLayerView.colors
                self.gradientLayerView.locations = gradientLayerView.locations
                self.gradientLayerView.startPoint = gradientLayerView.startPoint
                self.gradientLayerView.endPoint = gradientLayerView.endPoint
                self.gradientLayerView.layoutSubviews()
            } else {
                self.gradientLayerView.isHidden = true
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

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.layer.cornerRadius = backgroundImageView.frame.height / 2.0
    }

    private func prepareUI() {
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(gradientLayerView)
        addSubview(premiumBadgeImageView)
        setupLayout()
    }

    private func setupLayout() {
        backgroundImageView.fillSuperview(withPadding: .init(topPadding: 2, leftPadding: 2, bottomPadding: 2, rightPadding: 2))

        gradientLayerView.fillSuperview()

        premiumBadgeImageView.anchor(top: topAnchor,
                                     trailing: trailingAnchor,
                                     padding: .init(topPadding: -4, rightPadding: -4))
        premiumBadgeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        premiumBadgeImageView.heightAnchor.constraint(equalTo: premiumBadgeImageView.widthAnchor).isActive = true
    }

    
}

