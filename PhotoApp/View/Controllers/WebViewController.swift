//
//  WebViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit
import WebKit

@objc public class WebViewController: UIViewController {

    let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()

    var urlStringToLoad: String?

    init(urlStringToLoad url: String) {
        self.urlStringToLoad = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        if let urlStringToLoad = urlStringToLoad {
            webView.load(URLRequest(url: URL(string: urlStringToLoad)!))
        }
    }

    private func prepareUI() {

        view.addSubview(webView)

        let leftNavigationBarButton = UIBarButtonItem(image: UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftNavigationBarButtonTapped))
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                leftNavigationBarButton.tintColor = .white
            } else {
                leftNavigationBarButton.tintColor = .black
            }
        }
        navigationItem.leftBarButtonItem = leftNavigationBarButton

        setupLayout()
    }

    private func setupLayout() {
        webView.fillSuperview()
    }

    @objc func leftNavigationBarButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

