//
//  ShareVC.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import UIKit

class ShareVC: BaseVC {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    //: Variables
    var selectedImage: UIImage?
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            //: Save button
            self.saveButton.layer.cornerRadius = 6
            
            //: Container View
            self.imageContainerView.layer.cornerRadius = 18
            
            //: Image View
            self.imageView.layer.cornerRadius = 18
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        //: Back button
        self.backButton.addTarget(self, action: #selector(self.backButtonAction(_:)), for: .touchUpInside)
        
        //: Share button
        self.shareButton.addTarget(self, action: #selector(shareButtonAction(_:)), for: .touchUpInside)
        
        //: Save button
        self.saveButton.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
        
        //: Selected image
        guard let image = selectedImage else { return selectedImage = UIImage(named: "dummy3") }
        self.imageView.image = image
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func saveButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async { [self] in
            guard let image = imageView.image else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            let alert = UIAlertController(title: "Hello!", message: "Your photo has been saved.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func shareButtonAction(_ sender: UIButton) {
        guard let content = self.imageView.image else { return }
                
        let activityViewController = VisualActivityViewController(image: content)
        activityViewController.previewImageSideLength = 160
        
        self.presentActionSheet(activityViewController, from: sender)
    }
    
    @objc func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func presentActionSheet(_ vc: VisualActivityViewController, from view: UIView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = view
            vc.popoverPresentationController?.sourceRect = view.bounds
            vc.popoverPresentationController?.permittedArrowDirections = [.right, .left]
        }
        
        present(vc, animated: true, completion: nil)
    }
}
