//
//  TakePhotoViewController.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit 

class TakePhotoViewController: BaseVC {
    //MARK: - Properties
    //: Views
    
    //: Variables
    var editedImage : UIImage!
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
    }
    
    override func initListeners() {
        super.initListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
             let cameraViewController = ZLCustomCamera()
             
             
             ZLPhotoConfiguration.default()
                 .editImageClipRatios([.custom, .circle, .wh1x1, .wh3x4, .wh16x9, .wh2x3, .wh4x3, .wh9x16, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)])
     //            .filters([.normal, .process, ZLFilter(name: "custom", applier: ZLCustomFilter.hazeRemovalFilter)])
                 .imageStickerContainerView(ImageStickerContainerView())
                 .navCancelButtonStyle(.image)
                 // You can first determine whether the asset is allowed to be selected.
                 .hudStyle(.light)
                 .canSelectAsset { asset in
                     return true
                 }
                 .noAuthorityCallback { type in
                     switch type {
                         case .library:
                             debugPrint("No library authority")
                         case .camera:
                             debugPrint("No camera authority")
                         case .microphone:
                             debugPrint("No microphone authority")
                     }
                 }
             
             cameraViewController.cancelBlock = {
                 DispatchQueue.main.async {
                     self.tabBarController?.selectedIndex = 0
                     GlobalConstants.isCameraShown = false
                 }
             }
             
             cameraViewController.takeDoneBlock = { (image, localImageUrl) in
                 guard let editedImage = image else { return }
                 
                 self.editedImage = editedImage
                 
                 self.doneButtonObserver()
             }
             
             if !GlobalConstants.isCameraShown
             {
                 self.present(cameraViewController, animated: true, completion: nil)
             }
             else
             {
                 DispatchQueue.main.async {
                     self.tabBarController?.selectedIndex = 0
                     GlobalConstants.isCameraShown = true
                 }
             }
             
             
             let editViewController = ZLEditImageViewController(image: UIImage(named: "nature")!)
             
             editViewController.removeBackgroundBlock = { (image) in
              
                 guard let newImage = image.removedBg() else { return }
                 
                 print("imageView = ", newImage)
                 
                 editViewController.removedBackGroundBlock?(newImage)
             }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        GlobalConstants.isCameraShown = true
    }
    
    //MARK: - Public Functions
    func doneButtonObserver() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "shareViewSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareViewSegue"
        {
            guard let viewController = segue.destination as? ShareVC else { return }
            viewController.selectedImage = self.editedImage
        }
    }
    
    //MARK: - Actions
}
