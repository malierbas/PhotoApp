//
//  ContactUSVC.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import UIKit

class ContactUSVC: BaseVC {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var issueTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    //: Variables
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            self.saveButton.layer.cornerRadius = 6
            
            self.issueTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
            self.issueTextView.layer.borderWidth = 1
            self.issueTextView.layer.cornerRadius = 12
            
            self.hideKeyboardWhenTappedAround()
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            self.backButton.addTarget(self, action: #selector(self.backButtonAction(_:)), for: .touchUpInside)
            
            self.saveButton.addTarget(self, action: #selector(self.saveButtonAction(_:)), for: .touchUpInside)
        }
    }
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func saveButtonAction(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let alert = UIAlertController(title: "Hello!", message: "Your message has been sended.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //do something
        }
    }
}
