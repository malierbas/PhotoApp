//
//  PreviewInstagramControlsView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol PreviewInstagramControlsViewDelegate: class {
    @objc optional func closeButtonTapped(onControlsView controlsView: PreviewInstagramControlsView)
    @objc optional func sendToInstagramButtonTapped(onControlsView controlsView: PreviewInstagramControlsView)
}

class PreviewInstagramControlsView: UIView {

    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
        progressView.trackTintColor = UIColor(hex: "#A4A8B8").withAlphaComponent(0.4)
        progressView.progressTintColor = UIColor(hex: "#EAEAEA")
        progressView.layer.masksToBounds = true
        return progressView
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(hex: "#EAEBF0")
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.text = "Your Story"
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(hex: "#EAEBF0")
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = .init(leftPadding: 8, bottomPadding: 8)
        button.contentVerticalAlignment = .top
        button.contentHorizontalAlignment = .trailing
        return button
    }()

    private let sendToInstagramButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send To Instagram", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor(hex: "#1C1F21"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setImage(UIImage(named: "rightArrowIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentMode = .scaleAspectFit
        button.contentEdgeInsets = .init(leftPadding: 0, rightPadding: button.currentImage!.size.width + 8)
        button.addTarget(self, action: #selector(sendToInstagramButtonTapped), for: .touchUpInside)
        button.clipsToBounds = false
        return button
    }()

    weak var delegate: PreviewInstagramControlsViewDelegate?

    var hasSetAnimations: Bool = false

    init() {
        super.init(frame: .zero)
        prepareUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
        sendToInstagramButton.layer.cornerRadius = sendToInstagramButton.frame.height / 2.0
        progressView.layer.cornerRadius = progressView.frame.height / 2.0

        sendToInstagramButton.imageEdgeInsets = .init(leftPadding: (sendToInstagramButton.frame.size.width - (sendToInstagramButton.imageView!.frame.size.width + 24)))

        if !hasSetAnimations {
            UIView.animate(withDuration: 7, delay: 1, options: .curveLinear, animations: {
                self.progressView.setProgress(1, animated: true)
            }, completion: nil)
            hasSetAnimations = true
        }

        sendToInstagramButton.startPulsing()

    }

    private func prepareUI() {
        addSubviews(views: progressView, profileImageView, usernameLabel, closeButton, sendToInstagramButton)
        setupLayout()
    }

    private func setupLayout() {
        progressView.anchor(top: safeAreaLayoutGuide.topAnchor,
                            leading: leadingAnchor,
                            trailing: trailingAnchor,
                            padding: .init(topPadding: 10, leftPadding: 16, rightPadding: 16))

        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true

        profileImageView.anchor(top: progressView.bottomAnchor,
                                leading: leadingAnchor,
                                padding: .init(topPadding: 10, leftPadding: 16))
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true

        usernameLabel.anchor(leading: profileImageView.trailingAnchor, padding: .init(leftPadding: 8))
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true

        closeButton.anchor(top: progressView.bottomAnchor,
                           trailing: trailingAnchor,
                           padding: .init(topPadding: 16, rightPadding: 16))
        closeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor).isActive = true

        sendToInstagramButton.anchorCenterXToSuperview()
        sendToInstagramButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, padding: .init(bottomPadding: 24))
        sendToInstagramButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6).isActive = true
        sendToInstagramButton.heightAnchor.constraint(equalTo: sendToInstagramButton.widthAnchor, multiplier: 0.24).isActive = true

    }

    @objc func closeButtonTapped() {
        self.delegate?.closeButtonTapped?(onControlsView: self)
    }


    @objc func sendToInstagramButtonTapped() {
        self.delegate?.sendToInstagramButtonTapped?(onControlsView: self)
    }

}

