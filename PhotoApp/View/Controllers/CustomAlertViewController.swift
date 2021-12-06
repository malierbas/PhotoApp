//
//  CustomAlertViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class CustomAlertViewController: UIViewController {

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 23
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(topPadding: 28, leftPadding: 32, bottomPadding: 24, rightPadding: 32)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.customize(backgroundColor: UIColor(hexString: "#131314"), radiusSize: 12)
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    private let bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()

    lazy var callToActionButton: LoadingButton = {
        let button = LoadingButton(style: .gradientBackground)
        button.setTitle("Onayla", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .white
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(callToActionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Vazgeç", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.lightGray
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.tintColor = UIColor.lightGray
        return button
    }()

    lazy var inputTextFieldView: TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.textField.textAlignment = .center
        textFieldView.textField.font = UIFont.systemFont(ofSize: 24, weight: .light)
        textFieldView.textField.autocapitalizationType = .allCharacters
        textFieldView.tintColor = UIColor.white
        return textFieldView
    }()

    var isDismissable: Bool = true

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var subtitleText: String? {
        didSet {
            subtitleLabel.text = subtitleText
        }
    }
    var descriptionText: String? {
        didSet {
            descriptionLabel.text = descriptionText
        }
    }

    var bottomInfoText: String? {
        didSet {
            bottomInfoLabel.text = bottomInfoText
        }
    }

    var callToActionButtonTitle: String? {
        didSet {
            callToActionButton.setTitle(callToActionButtonTitle, for: .normal)
        }
    }
    var cancelButtonTitle: String? {
        didSet {
            cancelButton.setTitle(cancelButtonTitle, for: .normal)
        }
    }

    var inputFieldPlaceholderText: String? {
        didSet {
            inputTextFieldView.textFieldPlaceholderText = inputFieldPlaceholderText
        }
    }

    var hasInputField: Bool = false

    var callToActionButtonAction: (() -> ())?
    var cancelButtonAction: (() -> ())?

    init(titleText: String? = nil, image: UIImage? = nil, subtitleText: String? = nil, descriptionText: String? = nil, callToActionButtonTitle: String?, cancelButtonTitle: String? = nil, hasInputField: Bool = false, bottomInfoText: String? = nil) {
        self.titleText = titleText
        self.image = image
        self.subtitleText = subtitleText
        self.descriptionText = descriptionText
        self.callToActionButtonTitle = callToActionButtonTitle
        self.cancelButtonTitle = cancelButtonTitle
        self.hasInputField = hasInputField
        self.bottomInfoText = bottomInfoText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    private func prepareUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.67)

        view.addSubview(contentStackView)

        contentStackView.addSubview(closeButton)

        if titleText != nil {
            contentStackView.addArrangedSubview(titleLabel)
        }

        if image != nil {
            contentStackView.addArrangedSubview(imageView)
        }

        if subtitleText != nil {
            contentStackView.addArrangedSubview(subtitleLabel)
        }

        if descriptionText != nil {
            contentStackView.addArrangedSubview(descriptionLabel)
        }

        if hasInputField {
            contentStackView.addArrangedSubview(inputTextFieldView)
        }

        if callToActionButtonTitle != nil {
            contentStackView.addArrangedSubview(callToActionButton)
        }

        if cancelButtonTitle != nil {
            contentStackView.addArrangedSubview(cancelButton)
        }

        if bottomInfoText != nil {
            contentStackView.addArrangedSubview(bottomInfoLabel)
        }

        contentStackView.setCustomSpacing(28, after: descriptionLabel)
        contentStackView.setCustomSpacing(12, after: callToActionButton)
        contentStackView.setCustomSpacing(16, after: cancelButton)

        titleLabel.text = titleText
        imageView.image = image
        subtitleLabel.text = subtitleText
        descriptionLabel.text = descriptionText
        bottomInfoLabel.text = bottomInfoText
        inputTextFieldView.textFieldPlaceholderText = inputFieldPlaceholderText
        callToActionButton.setTitle(callToActionButtonTitle, for: .normal)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)

        closeButton.isHidden = !isDismissable

        setupLayout()

    }

    private func setupLayout() {
        contentStackView.anchorCenterSuperview()
        contentStackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true

        if image != nil {
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.5).isActive = true
        }

        inputTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        inputTextFieldView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        callToActionButton.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.814).isActive = true
        callToActionButton.heightAnchor.constraint(equalTo: callToActionButton.widthAnchor, multiplier: 0.185).isActive = true

        cancelButton.widthAnchor.constraint(equalTo: callToActionButton.widthAnchor, multiplier: 1.0).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: callToActionButton.heightAnchor, multiplier: 1.0).isActive = true

        closeButton.heightAnchor.constraint(equalToConstant: 21.2).isActive = true
        closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor).isActive = true
        closeButton.anchor(top: contentStackView.topAnchor, trailing: contentStackView.trailingAnchor, padding: .init(topPadding: 14.2, rightPadding: 12.5))
    }

    @objc func callToActionButtonTapped() {
        callToActionButtonAction?()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func cancelButtonTapped() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: { [weak self] in
                guard let self = self else { return }
                self.cancelButtonAction?()
            })
        }
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.cancelButtonAction?()
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard isDismissable else { return }
        if !contentStackView.frame.contains(touch.location(in: view)) {
            dismiss(animated: true, completion: nil)
        }
    }

}


