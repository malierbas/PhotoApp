//
//  OnboardingSecondVC.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import UIKit

class OnboardingSecondVC: BaseVC {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //: Variables
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            //: NextButton
            self.nextButton.layer.cornerRadius = 6
            
            //: Title Label
            self.titleLabel.text = "So strongly and \nmetap."
            
            //: Subtitle label
            self.subtitleLabel.text = "Get notifications \nand updates in real time."
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        self.nextButton.addTarget(self, action: #selector(self.nextButtonAction(_:)), for: .touchUpInside)
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func nextButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.nextPage()
        }
    }
    
    func nextPage() {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingThirdVC")

        window.rootViewController = vc

        let options: UIView.AnimationOptions = .transitionCrossDissolve

        let duration: TimeInterval = 0.3

        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
    }
}

