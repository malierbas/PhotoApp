//
//  Constants.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import Foundation
import UIKit

//MARK: - AppColors
struct AppColors {
    
    //MARK: - TextColors
    let softGreen: UIColor = UIColor(named: "SoftGreen")!
    
    //MARK: - ViewColors
    
    //MARK: - ButtonColors
    
    //MARK: - TabbarColors
    
}

//MARK: - Globals
let globalAppConstants = GlobalConstants()

class GlobalConstants {
    
    //MARK: - Variables
    public static var isCameraShown = false
    
    //MARK: - Mask Canvas Size
    public static var canvasType: Int = 0
    
    //: global app constants
    var forceUpdate: Bool?
    var shouldUpdate: Bool?

    var inAppPurchaseData: InAppPurchaseData?
}
