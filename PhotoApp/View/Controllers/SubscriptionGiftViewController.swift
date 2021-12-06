//
//  SubscriptionGiftViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit
import StoreKit

class SubscriptionGiftViewController: UIViewController {

  private let videoPlayerView: PlayerView = {
        let playerView = PlayerView()
        playerView.addBlur(style: .dark)
        return playerView
    }()

    private let valuePropositionsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gift-top"))
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

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#FFE66F")
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.text = timeString(time: LocalStorageManager.shared.weeklyGiftScarcityTimeLeft)
        return label
    }()

    private let topRightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bestOffer"))
        imageView.contentMode = .scaleAspectFit
        return imageView
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

//    private var videoPlayer: VideoPlayer?

    var weeklyGift: SKProduct?

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        if let weeklyGift = InAppPurchaseManager.shared.weeklyGift {
            self.weeklyGift = weeklyGift
        } else if Constants().inAppPurchaseData?.isWeeklyGiftActive ?? false {
            InAppPurchaseManager.shared.requestProducts(withIdentifiers: [InAppPurchaseManager.premiumWeekly]) { (success, products) in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    guard success, let products = products else { return }
                    InAppPurchaseManager.shared.weeklyGift = products.first
                    self.weeklyGift = InAppPurchaseManager.shared.weeklyGift
                }
            }
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: nil) { (_) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if LocalStorageManager.shared.isPremiumUser {
                    //(UIApplication.shared.delegate as? AppDelegate)?.confettiView.showConfettis(for: 5)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTriggered), userInfo: nil, repeats: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.shared.delegate as? AppDelegate)?.confettiView.showConfettis(for: 5)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func prepareUI() {

//        AnalyticsManager.shared.log(event: .weeklyGiftSceneOpened)

        view.addSubview(videoPlayerView)
        view.addSubview(closeButton)
        view.addSubview(topRightImageView)
        view.addSubview(valuePropositionsImageView)
        view.addSubview(timeLabel)
        view.addSubview(purchaseButton)

        purchaseButton.setTitle(Constants().inAppPurchaseData?.subscribeButtonTitle, for: .normal)

        if Constants().shouldUpdate == nil || Constants().shouldUpdate == true {
            closeButton.alpha = 1
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

        valuePropositionsImageView.anchorCenterYToSuperview(constant: -80)
        valuePropositionsImageView.anchorCenterXToSuperview()
        valuePropositionsImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.84).isActive = true
        valuePropositionsImageView.heightAnchor.constraint(equalTo: valuePropositionsImageView.widthAnchor, multiplier: 0.56).isActive = true

        timeLabel.anchor(top: valuePropositionsImageView.bottomAnchor, padding: .init(topPadding: 50))
        timeLabel.anchorCenterXToSuperview()

        topRightImageView.anchor(top: view.topAnchor, trailing: view.trailingAnchor)
        topRightImageView.widthAnchor.constraint(equalToConstant: 132).isActive = true
        topRightImageView.heightAnchor.constraint(equalTo: topRightImageView.widthAnchor, multiplier: 1).isActive = true

        purchaseButton.anchorCenterXToSuperview()
        purchaseButton.anchor(top: timeLabel.bottomAnchor, padding: .init(topPadding: 50))
        purchaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 52).isActive = true

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
        guard let weeklyGift = weeklyGift else { return }
        InAppPurchaseManager.shared.buyProduct(weeklyGift)
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func purchaseButtonTapped() {
//        AnalyticsManager.shared.log(event: .subscribeButtonTapped)
        UIImpactFeedbackGenerator().impactOccurred()
        purchaseSubscription()
    }

    @objc func timerTriggered() {
        LocalStorageManager.shared.weeklyGiftScarcityTimeLeft = max(0, LocalStorageManager.shared.weeklyGiftScarcityTimeLeft - 1)
        timeLabel.text = timeString(time: LocalStorageManager.shared.weeklyGiftScarcityTimeLeft)

        if LocalStorageManager.shared.weeklyGiftScarcityTimeLeft == 0 {
            timer?.invalidate()
        }
    }

    private func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }


}

