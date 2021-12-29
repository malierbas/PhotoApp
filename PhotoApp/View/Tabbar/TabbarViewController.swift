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
        
        //: Tabbar item y position
        if let centeredITem = self.tabBar.items?[2]
        {
            centeredITem.imageInsets = UIEdgeInsets(top: -15, left: 0, bottom: 15, right: 0)
        }
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
                print("tabbar item = 0")
            case 1:
                print("tabbar item = 1")
            case 2:
                print("tabbar item = 2")
            case 3:
                print("tabbar item = 3")
            case 4:
                print("tabbar item = 4")
            default:
                break
        }
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
