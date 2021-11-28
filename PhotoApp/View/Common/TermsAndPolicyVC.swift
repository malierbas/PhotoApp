//
//  TermsAndPolicyVC.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import UIKit
import WebKit

class TermsAndPolicyVC: BaseVC, WKNavigationDelegate {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    
    //: Variables
    public static var webUrl: String = "https://www.wordley.app/terms-en.html"
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            
            self.getViewSource()
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            self.backButton.addTarget(self, action: #selector(self.backButtonAction(_:)), for: .touchUpInside)
        }
    }
    //MARK: - Public Functions
    //GetViewSource
    func getViewSource() {
        DispatchQueue.main.async {
            self.webView.navigationDelegate = self
            if let url = URL(string: TermsAndPolicyVC.webUrl) {
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let text = webView.url?.absoluteString {
            print("web view title = ", text)
//            if text.contains("congrats") {
//
//            }
        }
    }
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //do something
        }
    }
}
