//
//  TabbarViewController.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit
import BottomPopup
import RevealingSplashView

class TabbarViewController: UITabBarController, BottomPopupDelegate {
    
    var revealingSplashView: RevealingSplashView?

    var hasAddedSplashView: Bool = false
    
    var currentEmptyCanvasItem : Template!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //: add gesture recognizer
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.imageItemClicked(gestureRec:)))
//        self.tabBar.addGestureRecognizer(gesture)
        
        //: Tabbar item y position
        if let centeredITem = self.tabBar.items?[2]
        {
            centeredITem.imageInsets = UIEdgeInsets(top: -15, left: 0, bottom: 15, right: 0)
        }
        
//        if selectedIndex == 2
//        {
//            print("mali = ")
//            self.showPopup()
//        }
        
//        guard let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
//        home.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "home"), selectedImage: UIImage(named: "home-selected"))
//
//        guard let searchEffectVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchEffectVC") as? SearchEffectVC else { return }
//        searchEffectVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "program"), selectedImage: UIImage(named: "program-selected"))
//
//        guard let bottomPP = UIStoryboard(name: "MainPopup", bundle: nil).instantiateViewController(withIdentifier: "M72-OA-TgW") as? BasePopupVC else { return }
//        bottomPP.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "music"), selectedImage: UIImage(named: "music-selected"))
//
//        guard let quotesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuotesVC") as? QuotesVC else { return }
//        quotesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile-selected"))
//
//        guard let settingsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC else { return }
//        settingsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile-selected"))
//
//        tabBar.unselectedItemTintColor = .white
//        tabBar.tintColor = .white
//        tabBar.isTranslucent = false
//        tabBar.layer.cornerRadius = 15
//        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        tabBar.layer.masksToBounds = true
//
//        viewControllers = [
//            InteractivePopNavigationController(rootViewController: home),
//            InteractivePopNavigationController(rootViewController: searchEffectVC),
//            InteractivePopNavigationController(rootViewController: bottomPP),
//            InteractivePopNavigationController(rootViewController: quotesVC),
//            InteractivePopNavigationController(rootViewController: settingsVC)
//        ]
    }
    
    override func viewDidLayoutSubviews() {
        let height = UIScreen.main.bounds.height - 65
        tabBar.frame = CGRect(x: 0, y: height ?? 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        super.viewDidLayoutSubviews()
    }
    
    //MARK: - Public Funtions
    func showPopup() {
        DispatchQueue.main.async {
            
            guard let popupVC = UIStoryboard(name: "MainPopup", bundle: nil).instantiateViewController(withIdentifier: "M72-OA-TgW") as? BasePopupVC else { return }
            popupVC.height = popupVC.view.frame.height * 1.3 / 3
            popupVC.topCornerRadius = 35
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.popupDelegate = self
            
            self.present(popupVC, animated: true, completion: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.getMaskView(notification:)), name: .init(rawValue: "canvas selected"), object: nil)
        }
    }
    
    //MARK: - Action
    @objc func imageItemClicked(gestureRec: UITapGestureRecognizer) {
        switch self.selectedIndex
        {
            case 0:
                print("memoli = 0")
            case 1:
                print("memoli = 1")
            case 2:
                print("memoli = 2")
            case 3:
                print("memoli = 3")
            case 4:
                print("memoli = 4")
            default:
                break
        }
        print("image item clicked")
    }
    
    @objc func getMaskView(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
           //: show empty canvas
            UIImpactFeedbackGenerator().impactOccurred()
            let editorViewController = EditorViewController()
            //: image container view
            switch GlobalConstants.canvasType
            {
                case 916:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 1)
                case 45:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 2)
                case 11:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 3)
                default:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 1)
            }
            editorViewController.template = self.currentEmptyCanvasItem
            self.presentInFullScreen(editorViewController, animated: true, completion: nil)
        }
    }
}
