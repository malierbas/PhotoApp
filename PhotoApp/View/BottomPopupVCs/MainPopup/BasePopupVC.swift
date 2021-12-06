//
//  BasePopupVC.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit
import BottomPopup

class BasePopupVC: BottomPopupNavigationController {
    //MARK: - Properties
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var disablesAutomaticKeyboardDismissals: Bool?
    var popupShouldBeganDismisss: Bool?
    
    var isKeyboardShowing = false
    var originY: CGFloat!
    
    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 1.0 }

    override var popupDismissDuration: Double { return dismissDuration ?? 1.0 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var disablesAutomaticKeyboardDismissal: Bool { return disablesAutomaticKeyboardDismissals ?? true }
    
    override var popupShouldBeganDismiss: Bool { return popupShouldBeganDismisss ?? true}
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //: setup ui
        self.setupUI()
        
        //: init listeners
        self.initListeners()
    }
    
    func setupUI() {
        DispatchQueue.main.async {
            
        }
    }
    
    func initListeners() {
        DispatchQueue.main.async {
            
        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
}
