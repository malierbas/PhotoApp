//
//  BaseVC.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit

class BaseVC: UIViewController {
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setupView
        setupView()
        //observe main notifications
        mainNotificationObserver()
    }
    
    //MARK: - Setups
    
    //setupView
    func setupView() {
        
        //initListener
        initListeners()
    }
    
    //init listener
    func initListeners() {
        
    }
    
    //MARK: - Observers
    func mainNotificationObserver() {
        
    }
}
