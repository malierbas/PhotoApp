//
//  File.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit
import MessageUI
import StoreKit
import SVProgressHUD

class AccountViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor(hexString: "#1C1F21")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor.clear
        tableView.contentInset = .init(topPadding: 32)
        return tableView
    }()

    enum Rows: Int, CaseIterable {
        case upgradeToPremium = 0
        case share
        case feedback
        case rateUs
        case instagram
        case termsOfUse
        case privacyPolicy
        case premiumCoupon

        var titleText: String {
            switch self {
                case .upgradeToPremium: return "Upgrade to Premium"
                case .share: return "Share Storia"
                case .feedback: return "Give Feedback"
                case .rateUs: return "Rate Us"
                case .instagram: return "Follow on Instagram"
                case .termsOfUse: return "Terms of Use"
                case .privacyPolicy: return "Privacy Policy"
                case .premiumCoupon: return "Premium Coupon"
            }
        }
    }

    var rows: [Rows] {
        return Rows.allCases.filter({ rowCase in
            var shouldContain: Bool = true
            if Constants().shouldUpdate == nil || Constants().shouldUpdate == true {
                if rowCase == .premiumCoupon {
                    shouldContain = false
                }
            }

            if LocalStorageManager.shared.isPremiumUser {
                if rowCase == .upgradeToPremium || rowCase == .premiumCoupon {
                    shouldContain = false
                }
            }

            return shouldContain
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func prepareUI() {
        view.backgroundColor = UIColor(hexString: "#1C1F21")
        navigationController?.view.backgroundColor = UIColor(hexString: "#1C1F21")

        tableView.register(UITableViewCell.self)
        view.addSubview(tableView)
        setupNavigationBar()
        setupLayout()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: nil) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                var title = "Unlock Premium"

                if Constants().shouldUpdate == false {
                    title = "Try for free"
                }

                if Constants().shouldUpdate == false && Constants().inAppPurchaseData?.isWeeklyGiftActive == true {
                    title = "Claim your gift 🎁"
                }
                self.navigationItem.rightBarButtonItem = LocalStorageManager.shared.isPremiumUser ? nil : UIBarButtonItem(title: title, style: .done, target: self, action: #selector(self.rightNavigationBarButtonItemTapped))
            }
        }

        addBackDoorForPremium()
    }
    
    private func setupLayout() {
        tableView.fillSuperview()
    }

    fileprivate func setupNavigationBar() {
        navigationItem.title = "Account"
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#1C1F21")

        if !LocalStorageManager.shared.isPremiumUser {
            var title = "Unlock Premium"

            if Constants().shouldUpdate == false {
                title = "Try for free"
            }

            if Constants().shouldUpdate == false && Constants().inAppPurchaseData?.isWeeklyGiftActive == true {
                title = "Claim your gift 🎁"
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightNavigationBarButtonItemTapped))
        }
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        navigationController!.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .medium),
            .foregroundColor: UIColor.white
        ]
    }

    @objc func rightNavigationBarButtonItemTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        if Constants().shouldUpdate == false && Constants().inAppPurchaseData?.isWeeklyGiftActive == true {
            presentInFullScreen(SubscriptionGiftViewController(), animated: true)
        } else {
            presentInFullScreen(SubscriptionViewController(), animated: true, completion: nil)
        }
    }

    fileprivate func rateApp() {
        SKStoreReviewController.requestReview()
    }

    fileprivate func addBackDoorForPremium() {
        let backDoorTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openBackDoorForPremium))
        backDoorTapGestureRecognizer.numberOfTapsRequired = 10
        tableView.addGestureRecognizer(backDoorTapGestureRecognizer)
    }

    @objc func openBackDoorForPremium() {
        LocalStorageManager.shared.isPremiumUser = true
    }

//    fileprivate func claimCoupon(code: String, withCompletionBlock completionBlock: @escaping (_ result: Result<Coupon>) -> ()) {
////        let networkManager = NetworkManager()
////        networkManager.request(StoriaEndpoint.couponClaim(code: code), completion: completionBlock)
//    }

}

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = rows[indexPath.row].titleText
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
}

extension AccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator().impactOccurred()
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedRow = Rows(rawValue: LocalStorageManager.shared.isPremiumUser ? indexPath.row + 1 : indexPath.row) else { return }

        switch selectedRow {
        case .feedback:
            sendEmail()
        case .privacyPolicy:
            let webViewController = WebViewController(urlStringToLoad: "https://sites.google.com/view/storia-app/privacy-policy")
            webViewController.title = "Privacy Policy"
            self.present(InteractivePopNavigationController(rootViewController: webViewController), animated: true, completion: nil)
        case .termsOfUse:
            let webViewController = WebViewController(urlStringToLoad: "https://sites.google.com/view/storia-app/terms-of-use")
            webViewController.title = "Terms of Use"
            self.present(InteractivePopNavigationController(rootViewController: webViewController), animated: true, completion: nil)
        case .rateUs:
            rateApp()
        case .share:
            let shareText = "You should see this app! I think you will love it.\n https://itunes.apple.com/app/id1471865028"
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            present(vc, animated: true)
//            AnalyticsManager.shared.log(event: .shareApp)
        case .upgradeToPremium:
            presentInFullScreen(SubscriptionViewController(), animated: true, completion: nil)
        case .instagram:
//            AnalyticsManager.shared.log(event: .openInstagramProfile)
            let instagramHooks = "instagram://user?username=app_storia"
            guard let instagramUrl = URL(string: instagramHooks) else { return }
            if UIApplication.shared.canOpenURL(instagramUrl) {
                UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
            } else {
                let webViewController = WebViewController(urlStringToLoad: "https://www.instagram.com/app_storia/")
                webViewController.title = "Storia on Instagram"
                self.presentInFullScreen(InteractivePopNavigationController(rootViewController: webViewController), animated: true, completion: nil)
            }
        case .premiumCoupon:
            let customAlertViewController = CustomAlertViewController(titleText: "Premium Coupon",
                                                                      callToActionButtonTitle: "Claim",
                                                                      cancelButtonTitle: "Cancel",
                                                                      hasInputField: true,
                                                                      bottomInfoText: "Want to earn premium coupon? Post a story tagging @app_storia. We will get in touch with you asap!")
            customAlertViewController.inputFieldPlaceholderText = "Enter coupon code"
            customAlertViewController.modalTransitionStyle = .crossDissolve
            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlertViewController.callToActionButtonAction = { [weak self] in
                guard let self = self else { return }
                guard let code = customAlertViewController.inputTextFieldView.textField.text else { return }
                customAlertViewController.callToActionButton.showLoading()
                
//                self.claimCoupon(code: code) { [weak self] result in
//                    guard let self = self else { return }
//                    customAlertViewController.callToActionButton.hideLoading()
//                    self.dismiss(animated: true, completion: nil)
//                    switch result {
//                        case .success(let coupon):
//                            if !LocalStorageManager.shared.isPremiumUser {
//                                LocalStorageManager.shared.isPremiumUser = true
//                                LocalStorageManager.shared.purchaseExpirationDate = coupon.products?.first?.expirationDate ?? Date()
//                                SVProgressHUD.showSuccess(withStatus: "Successful!")
//                                (UIApplication.shared.delegate as? AppDelegate)?.confettiView.showConfettis(for: 5)
//                            }
//                        case .error(let error):
//                            if let error = error as? NetworkStackError {
//                                switch error {
//                                case .requestNotSuccessful(let errorMessage):
//                                    SVProgressHUD.showError(withStatus: errorMessage)
//                                default:
//                                    SVProgressHUD.showError(withStatus: error.localizedDescription)
//                                }
//                            } else {
//                                SVProgressHUD.showError(withStatus: error.localizedDescription)
//                            }
//                    }
//                }
            }

            customAlertViewController.cancelButtonAction = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
            present(customAlertViewController, animated: true, completion: nil)

        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.backgroundColor = .clear
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center

    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .black
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = .white
    }
}

// Send Mail
extension AccountViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["heystoria.app@gmail.com"])
            mail.setMessageBody("<p>We value what you think! Tell us about your thoughts.</p>", isHTML: true)
            present(mail, animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


