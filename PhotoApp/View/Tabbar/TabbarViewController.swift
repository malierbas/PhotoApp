//
//  TabbarViewController.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit
import RevealingSplashView

class TabbarViewController: UITabBarController {
    
    var revealingSplashView: RevealingSplashView?

    var hasAddedSplashView: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

//        let networkManager = NetworkManager()
//        networkManager.request(StoriaEndpoint.constants) { (result: Result<Constants>) in
//            switch result {
//            case .success(let constants):
//                globalAppConstants = constants
//
//                self.prepareUI()
//
//                InAppPurchaseManager.shared.receiptValidation()
//
//                //Starts animation
//                self.revealingSplashView?.startAnimation() {
//                    LocalNotificationManager.shared.registerForRemoteNotifications()
//                }
//
//            case .error(let error):
//                print(error)
//            }
//        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

//        if !hasAddedSplashView {
//            //Initialize a revealing Splash with with the iconImage, the initial size and the background color
//            self.revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "icon-with-background-dark")!,
//                                                           iconInitialSize: CGSize(width: self.view.frame.width, height: self.view.frame.width * 319/414),
//                                                          backgroundColor: UIColor(hexString: "#1C1F21"))
//
//            //Adds the revealing splash view as a sub view
//            self.view.addSubview(self.revealingSplashView!)
//            hasAddedSplashView = true
//        }
    }
    
    private func prepareUI() {
        let templateSections = [
            TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
            TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
            TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
        ]
        let sectionSeeAllViewController = SectionSeeAllViewController()
        sectionSeeAllViewController.sections = templateSections
        sectionSeeAllViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "templates"), selectedImage: UIImage(named: "templates"))
        sectionSeeAllViewController.tabBarItem.imageInsets = .init(topPadding: 6, bottomPadding: -6)
        
        let accountViewController = AccountViewController()
        accountViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "account"), selectedImage: UIImage(named: "account"))
        accountViewController.tabBarItem.imageInsets = .init(topPadding: 6, bottomPadding: -6)
        viewControllers = [InteractivePopNavigationController(rootViewController: sectionSeeAllViewController) , InteractivePopNavigationController(rootViewController: accountViewController)]
        tabBar.tintColor = .white
        tabBar.barTintColor = UIColor(hexString: "#1C1F21")
        tabBar.isTranslucent = false
    }

    
}
