//
//  EditableTextEditModeView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit


@objc protocol EditableTextEditModeViewDelegate: class {
    @objc optional func didTapRemoveButton(onView view: EditableTextEditModeView)
    @objc optional func didTapEditButton(onView view: EditableTextEditModeView)
    @objc optional func didTapEditModeView(onView view: EditableTextEditModeView)
}

class EditableTextEditModeView: UIView {

    lazy var removeIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "closeIconWithBackground"))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeImageTapped))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()


    private let leftThumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "editableTextThumbs")
        return imageView
    }()

    weak var delegate: EditableTextEditModeViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareUI() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnEditModeView))
        addGestureRecognizer(tapGesture)

        addSubview(removeIconImageView)

        addSubview(leftThumbImageView)

        setupLayout()
    }

    private func setupLayout() {
        removeIconImageView.anchor(top: topAnchor,
                                   trailing: trailingAnchor,
                                   padding: .init(topPadding: 2, rightPadding: 2))
        removeIconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        removeIconImageView.widthAnchor.constraint(equalTo: removeIconImageView.heightAnchor, multiplier: 1.0).isActive = true

        let thumbSize: CGFloat = 16
        leftThumbImageView.anchor(leading: leadingAnchor, padding: .init(leftPadding: -thumbSize/2.0))
        leftThumbImageView.anchorCenterYToSuperview()
        leftThumbImageView.widthAnchor.constraint(equalToConstant: thumbSize).isActive = true
        leftThumbImageView.heightAnchor.constraint(equalTo: leftThumbImageView.widthAnchor).isActive = true
    }

    @objc func removeImageTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapRemoveButton?(onView: self)
    }

    @objc func editTextTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapEditButton?(onView: self)
    }

    @objc func tappedOnEditModeView() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapEditModeView?(onView: self)
    }

}
