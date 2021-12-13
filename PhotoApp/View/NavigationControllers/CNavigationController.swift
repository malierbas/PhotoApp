//
//  CNavigationController.swift
//  PhotoApp
//
//  Created by Ali on 12.12.2021.
//

import UIKit

class CNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //: prepare navigation
        let height: CGFloat = 50 //whatever height you want to add to the existing height
        let bounds = self.navigationBar.bounds
        self.navigationBar.frame = CGRect(x: 0, y: 20, width: bounds.width, height: bounds.height + height)
    }
}
