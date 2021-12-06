//
//  SubscriptionViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController {

    private let videoPlayerView: PlayerView = {
        let playerView = PlayerView()
        playerView.addBlur(style: .dark)
        return playerView
    }()

    private let valuePropositionsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "value-propositions"))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.alpha = 0.3
        return button
    }()

    private let purchaseButton: MainButton = {
        let button = MainButton(style: .gradientBackground)
        button.setTitle("Subscribe", for: .normal)
        button.addTarget(self, action: #selector(purchaseButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.layer.cornerRadius = 4
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return button
    }()

    private let restoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already Premium?", for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        button.addTarget(self, action: #selector(restoreButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return button
    }()

    private let bottomInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.text = "Payment will be charged to your iTunes account at the confirmation of purchase. The subscription will automatically renew unless auto-renew is turned off at least 24 hours before the end of current period."
        return label
    }()


    lazy var monthlySubscriptionView: InAppPurchaseProductSelectionView = {
        let monthlySubscriptionView = InAppPurchaseProductSelectionView()
        monthlySubscriptionView.discountPercent = "45"
        monthlySubscriptionView.originalPriceText = "$12,99"
        monthlySubscriptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(monthlySubscriptionViewTapped)))
        monthlySubscriptionView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return monthlySubscriptionView
    }()

    lazy var yearlySubscriptionView: InAppPurchaseProductSelectionView = {
        let yearlySubscriptionView = InAppPurchaseProductSelectionView()
        yearlySubscriptionView.discountPercent = "72"
        yearlySubscriptionView.originalPriceText = "$79,99"
        yearlySubscriptionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yearlySubscriptionViewTapped)))
        yearlySubscriptionView.isSelected = true
        yearlySubscriptionView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return yearlySubscriptionView
    }()

//    private var videoPlayer: VideoPlayer?

    var products: [SKProduct] = [] {
        didSet {
            if let firstProduct = products.first {
                monthlySubscriptionView.title = "Monthly " + firstProduct.getLocalizedPrice()

                let period = firstProduct.introductoryPrice?.subscriptionPeriod
                if let days = period?.numberOfUnits, days != 0 {
                    monthlySubscriptionView.subtitle = "\(days) days free trial"
                }
            }

            if let secondProduct = products.last {
                yearlySubscriptionView.title = "Yearly " + secondProduct.getLocalizedPrice()
                yearlySubscriptionView.subtitle = secondProduct.getLocalizedPrice(duration: 12) + " / month"
            }
        }
    }

    var selectedProduct: SKProduct? {
        if monthlySubscriptionView.isSelected ?? false {
            return products.first
        } else if yearlySubscriptionView.isSelected ?? false {
            return products.last
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        if !InAppPurchaseManager.shared.products.isEmpty {
            self.products = InAppPurchaseManager.shared.products
        } else {
            InAppPurchaseManager.shared.requestProducts { (success, products) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    guard success, let products = products else { return }
                    InAppPurchaseManager.shared.products = products
                    self.products = products
                }
            }
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: nil) { (_) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if LocalStorageManager.shared.isPremiumUser {
//                    (UIApplication.shared.delegate as? AppDelegate)?.confettiView.showConfettis(for: 5)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func prepareUI() {
//        AnalyticsManager.shared.log(event: .subscriptionSceneOpened)
        view.addSubview(videoPlayerView)
        view.addSubview(closeButton)
        view.addSubview(valuePropositionsImageView)
        view.addSubview(monthlySubscriptionView)
        view.addSubview(yearlySubscriptionView)
        view.addSubview(purchaseButton)
        view.addSubview(restoreButton)
        view.addSubview(bottomInfoLabel)

        purchaseButton.setTitle(Constants().inAppPurchaseData?.subscribeButtonTitle, for: .normal)

        if Constants().shouldUpdate == nil || Constants().shouldUpdate == true {
            closeButton.alpha = 1
            monthlySubscriptionView.originalPriceLabel.isHidden = true
            monthlySubscriptionView.discountBadgeView.isHidden = true

            yearlySubscriptionView.originalPriceLabel.isHidden = true
            yearlySubscriptionView.discountBadgeView.isHidden = true
            
        } else if Constants().shouldUpdate == false {
            bottomInfoLabel.isHidden = true
        }

        prepareVideoPlayer()
        setupLayout()
    }

    private func setupLayout() {
        videoPlayerView.fillSuperview()

        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                           leading: view.leadingAnchor, padding: .init(topPadding: 8, leftPadding: 8))
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let topImageTopConstraint = valuePropositionsImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20)
        topImageTopConstraint.priority = .defaultLow
        topImageTopConstraint.isActive = true

        valuePropositionsImageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        valuePropositionsImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.7).isActive = true

        let topImageWidthConstraint = valuePropositionsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7)
        topImageWidthConstraint.priority = .defaultLow
        topImageWidthConstraint.isActive = true
        valuePropositionsImageView.heightAnchor.constraint(equalTo: valuePropositionsImageView.widthAnchor, multiplier: 1.1).isActive = true
        valuePropositionsImageView.anchorCenterXToSuperview()

        monthlySubscriptionView.anchor(top: valuePropositionsImageView.bottomAnchor, padding: .init(topPadding: 36))
        monthlySubscriptionView.anchorCenterXToSuperview()
        monthlySubscriptionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        monthlySubscriptionView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        yearlySubscriptionView.anchor(top: monthlySubscriptionView.bottomAnchor, padding: .init(topPadding: 10))
        yearlySubscriptionView.anchorCenterXToSuperview()
        yearlySubscriptionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        yearlySubscriptionView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        purchaseButton.anchorCenterXToSuperview()
        purchaseButton.anchor(top: yearlySubscriptionView.bottomAnchor, padding: .init(topPadding: 24))
        purchaseButton.bottomAnchor.constraint(lessThanOrEqualTo: restoreButton.topAnchor, constant: -20).isActive = true
        purchaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

        restoreButton.anchor(bottom: bottomInfoLabel.topAnchor, padding: .init(bottomPadding: 8))
        restoreButton.anchorCenterXToSuperview()
        restoreButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true

        bottomInfoLabel.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(bottomPadding: 4))
        bottomInfoLabel.anchorCenterXToSuperview()
        bottomInfoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true

    }

    private func prepareVideoPlayer() {
        if let filePath = Bundle.main.path(forResource: "1", ofType: "mp4") {
            let fileURL = NSURL(fileURLWithPath: filePath)
//            videoPlayer = VideoPlayer(urlAsset: fileURL, view: videoPlayerView)
//            if let player = videoPlayer {
//                player.playerRate = 0.67
//            }
        }
    }
    
    private func purchaseSubscription() {
        guard let selectedProduct = selectedProduct else { return }
        InAppPurchaseManager.shared.buyProduct(selectedProduct)
    }

    private func restorePurchases() {
        InAppPurchaseManager.shared.restorePurchases()
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func purchaseButtonTapped() {
//        wAnalyticsManager.shared.log(event: .subscribeButtonTapped)
        UIImpactFeedbackGenerator().impactOccurred()
        purchaseSubscription()
    }

    @objc func restoreButtonTapped() {
        restorePurchases()
    }

    @objc func monthlySubscriptionViewTapped() {
        UISelectionFeedbackGenerator().selectionChanged()
        yearlySubscriptionView.isSelected = false
        monthlySubscriptionView.isSelected = true
    }

    @objc func yearlySubscriptionViewTapped() {
        UISelectionFeedbackGenerator().selectionChanged()
        yearlySubscriptionView.isSelected = true
        monthlySubscriptionView.isSelected = false
    }
}

