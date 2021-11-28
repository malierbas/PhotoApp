//
//  Switcher.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import Foundation
import UIKit

class Switcher {

    //MARK: - Update Root VC
    static func updateRootVC(){
        var rootVC : UIViewController?
        
        if(!globalUserPreferences.isUserLoggedIn){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnboardingMainVC") as! OnboardingMainVC
            
            globalUserPreferences.isUserLoggedIn = true
            globalUserPreferences.token = UUID().uuidString
            print("global user token = ", globalUserPreferences.token)
            
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
        }
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
       
        window.rootViewController = rootVC

        let options: UIView.AnimationOptions = .transitionCrossDissolve

        let duration: TimeInterval = 0.1

        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
    }
}