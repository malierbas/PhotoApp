//
//  StickerViewEditModeView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol StickerViewEditModeViewDelegate: class {
    @objc optional func didTapRemoveButton(onView view: StickerViewEditModeView)
    @objc optional func didTapEditModeView(onView view: StickerViewEditModeView)
}

class StickerViewEditModeView: UIView {

    lazy var removeIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "closeIconWithBackground"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    weak var delegate: StickerViewEditModeViewDelegate?

    var padding: CGFloat = 4

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func prepareUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnEditModeView))
        addGestureRecognizer(tapGesture)

        addSubview(removeIconImageView)
        setupLayout()
    }

    private func setupLayout() {
        removeIconImageView.anchor(top: topAnchor,
                                   trailing: trailingAnchor,
                                   padding: .init(topPadding: padding, rightPadding: padding))
        removeIconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        removeIconImageView.widthAnchor.constraint(equalTo: removeIconImageView.heightAnchor, multiplier: 1.0).isActive = true

    }

    @objc func removeImageTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapRemoveButton?(onView: self)
    }

    @objc func tappedOnEditModeView() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapEditModeView?(onView: self)
    }

}
