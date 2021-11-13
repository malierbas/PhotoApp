//
//  ChangeBackgroundViewController.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit


class ChangeBackgroundViewController: BaseVC {
    //MARK: - Properties
    private var imageContentView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        return uiView
    }()
    
    private var currentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "backgrounds2")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var editedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "nature")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private var bottomImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        //AddViews
        self.view.addSubview(imageContentView)
        
        self.imageContentView.addSubview(editedImageView)
        
        self.editedImageView.addSubview(currentImageView)
        
        //Change Positions
        
        //image content view
        self.imageContentView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        self.imageContentView.heightAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        self.imageContentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.imageContentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.imageContentView.translatesAutoresizingMaskIntoConstraints = false
        
        //first imageView
        self.editedImageView.widthAnchor.constraint(equalToConstant: self.imageContentView.frame.width).isActive = true
        self.editedImageView.heightAnchor.constraint(equalToConstant: self.imageContentView.frame.height).isActive = true
        self.editedImageView.leadingAnchor.constraint(equalTo: self.imageContentView.leadingAnchor, constant: 0).isActive = true
        self.editedImageView.trailingAnchor.constraint(equalTo: self.imageContentView.trailingAnchor, constant: 0).isActive = true
        self.editedImageView.topAnchor.constraint(equalTo: self.imageContentView.topAnchor, constant: 0).isActive = true
        self.editedImageView.bottomAnchor.constraint(equalTo: self.imageContentView.bottomAnchor, constant: 0).isActive = true
        self.editedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //second imageView
        let image = UIImage(named: "nature")!
        let aspectRatio = (image.size.height / image.size.width) + 0.1
        
        print("aspect ratio = ", aspectRatio)
        
        let aspectRatioConstraint = NSLayoutConstraint(item: currentImageView,attribute: .height,relatedBy: .equal,toItem: currentImageView,attribute: .width,multiplier: aspectRatio,constant: 0)
        
        currentImageView.addConstraint(aspectRatioConstraint)
        
        self.currentImageView.centerYAnchor.constraint(equalTo: self.editedImageView.centerYAnchor, constant: -aspectRatio).isActive = true
        self.currentImageView.centerXAnchor.constraint(equalTo: self.editedImageView.centerXAnchor, constant: 0).isActive = true
        self.currentImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func initListeners() {
        super.initListeners()
    }
    
    //MARK: - Public Functions
    
    //MARK: - Save with shake
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        self.savePhotosAlbum()
    }
    
    //MARK: - Actions
    //save current photo
    func savePhotosAlbum() {
        UIImageWriteToSavedPhotosAlbum(self.imageContentView.asImage(), nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Filtered Image Saved!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
