//
//  SelectSizeBottomPopup.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit
import BottomPopup

class SelectSizeBottomPopup: BottomPopupViewController {
    //MARK: - Properties
    //:  BottomPopupDelegates
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override var popupHeight: CGFloat { height ?? 300.0 }
    override var popupTopCornerRadius: CGFloat { topCornerRadius ?? 10.0 }
    override var popupPresentDuration: Double { presentDuration ?? 1.0 }
    override var popupDismissDuration: Double { dismissDuration ?? 1.0 }
    override var popupShouldDismissInteractivelty: Bool { shouldDismissInteractivelty ?? true }
    
    //: Views
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var firstStoryCanvasSelection: UIView!
    @IBOutlet weak var secondPostCanvasSelection: UIView!
    @IBOutlet weak var postCanvasSelection: UIView!
    
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var secondPostImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    
    //: Variables
    var isSizeSelected: Bool = false
    

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //: setup view
        self.setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if !self.isSizeSelected
        {
            NotificationCenter.default.post(name: .init(rawValue: "return home"), object: nil)
        }
    }
    
    func setupView() {
        DispatchQueue.main.async {
            
            //: Setup Constraints
            self.setupConstraints()
            
            //: Init listeners
            self.initListeners()
        }
    }
    
    func setupConstraints() {
        DispatchQueue.main.async {
        }
    }
    
    func initListeners() {
        DispatchQueue.main.async {
            let firstStoryGesture = UITapGestureRecognizer(target: self, action: #selector(self.firstStoryAction))
            self.firstStoryCanvasSelection.addGestureRecognizer(firstStoryGesture)
            self.storyImageView.isUserInteractionEnabled = true
            self.storyImageView.addGestureRecognizer(firstStoryGesture)
            
            let secondPostGesture = UITapGestureRecognizer(target: self, action: #selector(self.secondPostAction))
            self.secondPostImageView.isUserInteractionEnabled = true
            self.secondPostImageView.addGestureRecognizer(secondPostGesture)
            self.secondPostCanvasSelection.addGestureRecognizer(secondPostGesture)
            
            let postGesture = UITapGestureRecognizer(target: self, action: #selector(self.postAction))
            self.postImageView.isUserInteractionEnabled = true
            self.postImageView.addGestureRecognizer(postGesture)
            self.postCanvasSelection.addGestureRecognizer(postGesture)
            
        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func firstStoryAction() {
        //: first canvas
        isSizeSelected = true
        GlobalConstants.canvasType = 916
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .init(rawValue: "canvas selected"), object: nil, userInfo: nil)
            }
        }
    }
    
    @objc func secondPostAction() {
        //: center canvas
        isSizeSelected = true
        GlobalConstants.canvasType = 45
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .init(rawValue: "canvas selected"), object: nil, userInfo: nil)
            }
        }
    }
    
    @objc func postAction() {
        //: last canvas
        isSizeSelected = true
        GlobalConstants.canvasType = 11
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: .init(rawValue: "canvas selected"), object: nil, userInfo: nil)
            }
        }
    }
}
