//
//  ShareViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit
import SVProgressHUD

protocol ShareViewControllerDelegate: class {
    func willStartSaving(withCompletionBlock completionBlock: ((_ image: UIImage) -> Void)?)
    func didFinishSaving()
}

class ShareViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hexString: "#131314")
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.layer.cornerRadius = 32
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#DBDBDB")
        view.layer.cornerRadius = 1.5
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()
    
    private let titleSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#CDCDCD").withAlphaComponent(0.6)
        view.isHidden = true
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let shareToInstagramButton: TableRowButton = {
        let button = TableRowButton(type: .system)
        button.leftIconImage = #imageLiteral(resourceName: "instagramIcon").withRenderingMode(.alwaysTemplate)
        button.hasBottomLineView = false
        button.tintColor = .white
        button.setTitle("Share to Instagram Story", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(shareToInstagramButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        return button
    }()
    
    private let saveToPhotoLibraryButton: TableRowButton = {
        let button = TableRowButton(type: .system)
        button.leftIconImage = #imageLiteral(resourceName: "downloadIcon").withRenderingMode(.alwaysTemplate)
        button.hasBottomLineView = false
        button.setTitle("Save to Photo Library", for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(saveToPhotoLibraryButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        return button
    }()
    
    private var scrollViewBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: ShareViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(scrollView)
        scrollView.addSubview(topLineView)
        scrollView.addSubview(closeButton)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleSeparatorLineView)
        
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(shareToInstagramButton)
        contentStackView.addArrangedSubview(saveToPhotoLibraryButton)
        
        titleLabel.text = "Share"

        // add swipe down gesture
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGestureRecognized))
        swipeDownGesture.direction = .down
        scrollView.addGestureRecognizer(swipeDownGesture)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateScrollView(withCompletion: nil)
    }
    
    private func setupLayout() {
        scrollView.anchor(leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomConstraint.isActive = true
        scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.36).isActive = true
        
        topLineView.anchor(top: scrollView.topAnchor, padding: .init(topPadding: 14))
        topLineView.anchorCenterXToSuperview()
        topLineView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
        closeButton.anchor(top: scrollView.topAnchor,
                           trailing: view.trailingAnchor, padding: .init(topPadding: 16, rightPadding: 16))
        closeButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        titleLabel.anchor(top: scrollView.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: closeButton.leadingAnchor, padding: .init(topPadding: 30, leftPadding: 22, rightPadding: 10))
        
        titleSeparatorLineView.anchor(top: titleLabel.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor, padding: .init(topPadding: 16))
        titleSeparatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        contentStackView.anchor(top: titleSeparatorLineView.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor)
        
        shareToInstagramButton.translatesAutoresizingMaskIntoConstraints = false
        shareToInstagramButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        saveToPhotoLibraryButton.translatesAutoresizingMaskIntoConstraints = false
        saveToPhotoLibraryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = scrollView.frame.height
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: scrollView)
        let userBufferInPointsToMistakenlyTapAboveScrollView: CGFloat = 20
        if (touchLocation.y < -userBufferInPointsToMistakenlyTapAboveScrollView) { // empty space area tapped.
            closeButtonTapped()
        }
    }
    
    private func animateScrollView(withCompletion completion: ((_ success: Bool) -> ())?) {
        view.layoutIfNeeded()
        if self.scrollViewBottomConstraint.constant > 0 { // should show
            self.scrollViewBottomConstraint.constant = 0
        } else { // should hide
            self.scrollViewBottomConstraint.constant = scrollView.frame.height
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func shareToInstagramStories() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.delegate?.willStartSaving(withCompletionBlock: { [weak self] (image) in
            guard let self = self else { return }
            guard let imagePNGData = image.pngData() else { return }
            guard let instagramStoryUrl = URL(string: "instagram-stories://share") else { return }
            guard UIApplication.shared.canOpenURL(instagramStoryUrl) else { return }

            let itemsToShare: [[String: Any]] = [[
                "com.instagram.sharedSticker.backgroundImage": imagePNGData,
                "com.instagram.sharedSticker.backgroundTopColor": "#FFFFFF",
                "com.instagram.sharedSticker.backgroundBottomColor": "#FFFFFF"
                ]]
            let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
            UIPasteboard.general.setItems(itemsToShare, options: pasteboardOptions)
            UIApplication.shared.open(instagramStoryUrl, options: [:], completionHandler: { _ in
                self.delegate?.didFinishSaving()
            })

            self.animateScrollView(withCompletion: nil)
        })
    }
    
    @objc func saveToPhotoLibraryButtonTapped() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        UIImpactFeedbackGenerator().impactOccurred()
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        self.delegate?.willStartSaving(withCompletionBlock: { [weak self] (image) in
            guard let self = self else { return }
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            // we got back an error!
            DispatchQueue.main.async {
                SVProgressHUD.showError(withStatus: "Saving failed.")
                SVProgressHUD.dismiss(withDelay: 1)
            }
           
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.showSuccess(withStatus: "Saved!")
                SVProgressHUD.dismiss(withDelay: 1)
            }
           
        }
        animateScrollView(withCompletion: nil)
        self.delegate?.didFinishSaving()
        UIColor.black.withAlphaComponent(0.4)
    }
    
    @objc func closeButtonTapped() {
        animateScrollView(withCompletion: nil)
    }
    
    @objc func shareToInstagramButtonTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        shareToInstagramStories()
    }

    @objc func swipeDownGestureRecognized(_ gestureRecognizer: UISwipeGestureRecognizer) {
        animateScrollView(withCompletion: nil)
    }

}

