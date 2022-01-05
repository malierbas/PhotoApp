//
//  SettingsVC.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import UIKit

class SettingsVC: BaseVC {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var termsAndPolicyView: UIView!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //: Variables
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            let termsAndPolicyGesture = UITapGestureRecognizer(target: self, action: #selector(self.showTermsPolicy))
            self.termsAndPolicyView.addGestureRecognizer(termsAndPolicyGesture)
            
            let contactUsGesture = UITapGestureRecognizer(target: self, action: #selector(self.showContactUs))
            self.contactUsView.addGestureRecognizer(contactUsGesture)
            
            let showFavsGesture = UITapGestureRecognizer(target: self, action: #selector(self.showFavs))
            self.favouritesView.addGestureRecognizer(showFavsGesture)
            
            //: - premium notification -
            NotificationCenter.default.addObserver(forName: .init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: .main) { notification in
                if LocalStorageManager.shared.isOfferViewShown
                {
                    //: hide offer view
                    DispatchQueue.main.async {
                        //: - do something -
                    }
                }
            }
        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func showTermsPolicy() {
        print("terms policy active")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "termsAndPolicyView", sender: nil)
        }
    }
    
    @objc func showContactUs() {
        print("contact us active")
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "contactUsView", sender: nil)
        }
    }
    
    @objc func showFavs() {
        print("show favs active")
    }
}
