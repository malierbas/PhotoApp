//
//  SplashViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit
import DWAnimatedLabel

class SplashViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon-with-background-dark")
        imageView.isHidden = true
        return imageView
    }()

    private let sloganLabel: DWAnimatedLabel = {
        let label = DWAnimatedLabel()
        label.text = "Stories are memories"
//        label.font = UIFont(name: "Tangerine-Bold", size: 60)
        label.font = UIFont.systemFont(ofSize: 36, weight: .light)
        label.textAlignment = .center
        label.animationType = DWAnimationType.shine
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    var backgroundImageCenterYConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    private func prepareUI() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(sloganLabel)
        setupLayout()
    }

    private func setupLayout() {
        backgroundImageView.anchor(leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor)
        backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor,
                                                    multiplier: 319/414).isActive = true
        backgroundImageCenterYConstraint = backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        backgroundImageCenterYConstraint.isActive = true

        sloganLabel.anchor(top: backgroundImageView.bottomAnchor,
                           leading: backgroundImageView.leadingAnchor,
                           trailing: backgroundImageView.trailingAnchor,
                           padding: .init(topPadding: 10))
    }

    private func animateSplashWithText() {
        backgroundImageCenterYConstraint.constant = -80
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }) { [weak self] (_) in
            guard let self = self else { return }
            self.sloganLabel.startAnimation(duration: 1.6, {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: true, completion: nil)
                })
            })
        }
    }

}

