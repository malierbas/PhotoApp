//
//  PurchaseTimerViewController.swift
//  PhotoApp
//
//  Created by Ali on 19.12.2021.
//

import UIKit

class PurchaseTimerViewController: BaseVC {
    //MARK: - Properties
    //: views
    @IBOutlet weak var scrollView: IKScrollView!
    
    @IBOutlet weak var backButton: UIImageView!
    
    @IBOutlet weak var timerBackgroundview: UIImageView!
    
    @IBOutlet weak var timerOneView: UIView!
    @IBOutlet weak var timerOneLAbel: UILabel!
    
    @IBOutlet weak var timerTwoView: UIView!
    @IBOutlet weak var timerTwoLAbel: UILabel!
    
    @IBOutlet weak var timerThreeView: UIView!
    @IBOutlet weak var timerThreeLabel: UILabel!
    
    @IBOutlet weak var continueButtonOutlet: UIButton!
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var restoreLabel: UILabel!
    
    //: variables
    var seconds = 90000
    var timer = Timer()
    var isTimerRunning = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            //: timer view
            self.timerBackgroundview.layer.cornerRadius = 12
            
            self.timerOneView.layer.cornerRadius = 4
            self.timerTwoView.layer.cornerRadius = 4
            self.timerThreeView.layer.cornerRadius = 4
            
            //: run timer
            self.runTimer()
            self.updateTimer()
            
            //: continue
            self.continueButtonOutlet.layer.cornerRadius = self.continueButtonOutlet.frame.height / 2
            
            //: back button
            self.backButton.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.backButtonAction))
            self.backButton.addGestureRecognizer(gesture)
            
            //: scroll view
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.isScrollEnabled = false
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    //MARK: - Public Functions
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time: TimeInterval) {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        self.timerOneLAbel.text = String(hours)
        self.timerTwoLAbel.text = String(minutes)
        self.timerThreeLabel.text = String(second)
        
        LocalStorageManager.shared.offerTimerTime = Int(time)
    }
    //MARK: - Actions
     
    @objc func backButtonAction() {
        self.dismiss(animated: true) {
            //: do something
        }
    }
}
