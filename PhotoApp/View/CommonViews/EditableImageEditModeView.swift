//
//  EditableImageEditModeView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol EditableImageEditModeViewDelegate: class {
    @objc optional func didTapRemoveButton(onView view: EditableImageEditModeView)
    @objc optional func didTapEditButton(onView view: EditableImageEditModeView)
    @objc optional func didTapEditModeView(onView view: EditableImageEditModeView)
}

class EditableImageEditModeView: UIView {

    lazy var removeIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "closeIconWithBackground"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var editIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "editIconWithBackground"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    weak var delegate: EditableImageEditModeViewDelegate?

    var padding: CGFloat = 10.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func prepareUI() {
        layer.zPosition = 1000
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnEditModeView))
        addGestureRecognizer(tapGesture)

        addSubview(removeIconImageView)
        addSubview(editIconImageView)
        setupLayout()
    }

    private func setupLayout() {
        removeIconImageView.anchor(top: topAnchor,
                                  trailing: trailingAnchor,
                                  padding: .init(topPadding: padding, rightPadding: padding))
        removeIconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        removeIconImageView.widthAnchor.constraint(equalTo: removeIconImageView.heightAnchor, multiplier: 1.0).isActive = true

        editIconImageView.anchor(trailing: trailingAnchor,
                                 bottom: bottomAnchor,
                                 padding: .init(bottomPadding: padding, rightPadding: padding))
        editIconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editIconImageView.widthAnchor.constraint(equalTo: removeIconImageView.heightAnchor, multiplier: 1.0).isActive = true

    }

    @objc func removeImageTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapRemoveButton?(onView: self)
    }

    @objc func editImageTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapEditButton?(onView: self)
    }

    @objc func tappedOnEditModeView() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapEditModeView?(onView: self)
    }

}

