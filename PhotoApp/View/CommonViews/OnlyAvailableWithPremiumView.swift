//
//  OnlyAvailableWithPremiumView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

protocol OnlyAvailableWithPremiumViewDelegate: class {
    func tryForFreeButtonTapped(onView view: OnlyAvailableWithPremiumView)
    func bottomRemoveButtonTapped(onView view: OnlyAvailableWithPremiumView)
}

class OnlyAvailableWithPremiumView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Only available with Storia Premium"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private lazy var tryForFreeButton: MainButton = {
        let button = MainButton(style: .gradientBackground)
        button.setTitle("Unlock Premium", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(tryForFreeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var bottomRemoveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(bottomRemoveButtonTapped), for: .touchUpInside)
        return button
    }()

    weak var delegate: OnlyAvailableWithPremiumViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8

        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor(hexString: "#02D5FF").cgColor

    }

    private func prepareUI() {
        backgroundColor = UIColor(hexString: "#1C1E1D")
        addSubview(titleLabel)
        addSubview(tryForFreeButton)
        addSubview(bottomRemoveButton)

        var title = "Unlock Premium"
        if globalAppConstants.shouldUpdate == false {
            title = "Try for free"
        }

        tryForFreeButton.setTitle(title, for: .normal)

        setupLayout()
    }

    private func setupLayout() {
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          trailing: centerXAnchor,
                          padding: .init(topPadding: 20, leftPadding: 12))

        tryForFreeButton.anchorCenterYToSuperview()
        tryForFreeButton.anchor(trailing: trailingAnchor, padding: .init(rightPadding: 12))
        tryForFreeButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.44).isActive = true
        tryForFreeButton.widthAnchor.constraint(equalTo: tryForFreeButton.heightAnchor, multiplier: 3.2).isActive = true

        bottomRemoveButton.anchor(top: titleLabel.bottomAnchor,
                                  leading: titleLabel.leadingAnchor,
                                  padding: .init(topPadding: 2))


    }

    @objc func tryForFreeButtonTapped() {
        self.delegate?.tryForFreeButtonTapped(onView: self)
    }

    @objc func bottomRemoveButtonTapped() {
        self.delegate?.bottomRemoveButtonTapped(onView: self)
    }

}
