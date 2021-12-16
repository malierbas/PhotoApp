//
//  PaywallViewController.swift
//  PhotoApp
//
//  Created by Ali on 16.12.2021.
//

import UIKit

class PaywallViewController: BaseVC {
    //MARK: - Properties
    //: view
    @IBOutlet weak var bottomView: UIView!
    
    //: variables
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            self.bottomView.layer.cornerRadius = 40
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions

}
