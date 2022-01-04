//
//  PreviewViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class PreviewViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var instagramControlsView: PreviewInstagramControlsView = {
        let instagramControlsView = PreviewInstagramControlsView()
        instagramControlsView.delegate = self
        return instagramControlsView
    }()

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    init(image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
        imageView.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func prepareUI() {
        view.backgroundColor = UIColor(hexString: "#1C1F21")

        view.addSubview(imageView)
        view.addSubview(instagramControlsView)

        // gestures
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipe.direction = [.down, .up]
        view.addGestureRecognizer(swipe)

        setupLayout()
    }

    private func setupLayout() {
        imageView.fillSuperview()
        instagramControlsView.fillSuperview()
    }

    @objc func handleTapGesture() {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: {
            self.instagramControlsView.alpha = self.instagramControlsView.alpha == 0 ? 1 : 0
        }, completion: nil)
    }

    @objc func handleSwipeGesture() {
        dismiss(animated: true, completion: nil)
    }
}

extension PreviewViewController: PreviewInstagramControlsViewDelegate {
    func closeButtonTapped(onControlsView controlsView: PreviewInstagramControlsView) {
        dismiss(animated: true, completion: nil)
    }

    func sendToInstagramButtonTapped(onControlsView controlsView: PreviewInstagramControlsView) {
        guard let imagePNGData = image?.pngData() else { return }
        guard let instagramStoryUrl = URL(string: "instagram-stories://share") else { return }
        guard UIApplication.shared.canOpenURL(instagramStoryUrl) else { return }

        let itemsToShare: [[String: Any]] = [[
            "com.instagram.sharedSticker.backgroundImage": imagePNGData,
            "com.instagram.sharedSticker.backgroundTopColor": "#FFFFFF",
            "com.instagram.sharedSticker.backgroundBottomColor": "#FFFFFF"
            ]]
        let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
        UIPasteboard.general.setItems(itemsToShare, options: pasteboardOptions)
        UIApplication.shared.open(instagramStoryUrl, options: [:], completionHandler: nil)
//        AnalyticsManager.shared.log(event: .exportedTemplate, withParameters: ["to": "instagram"])
    }
}


