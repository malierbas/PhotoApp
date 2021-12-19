//
//  TakePhotoViewController.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit 
import BottomPopup

class TakePhotoViewController: BaseVC, BottomPopupDelegate {
    //MARK: - Properties
    //: Views
    
    //: Variables
    var editedImage : UIImage!
    
    var currentEmptyCanvasItem : Template!
    
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
            self.view.backgroundColor = UIColor(named: "ViewBlackBG")
            
            if !GlobalConstants.isCameraShown
            {
                self.showPopup()
            }
            else
            {
                DispatchQueue.main.async {
                    self.tabBarController?.selectedIndex = 0
                    GlobalConstants.isCameraShown = true
                }
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
    
    func showPopup() {
        DispatchQueue.main.async {
            
            guard let popupVC = UIStoryboard(name: "MainPopup", bundle: nil).instantiateViewController(withIdentifier: "M72-OA-TgW") as? BasePopupVC else { return }
            popupVC.height = popupVC.view.frame.height * 1.3 / 3
            popupVC.topCornerRadius = 35
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.popupDelegate = self
            
            self.present(popupVC, animated: true, completion: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.getMaskView(notification:)), name: .init(rawValue: "canvas selected"), object: nil)
        }
    }
    
    //MARK: - Actions
    @objc func getMaskView(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
           //: show empty canvas
            UIImpactFeedbackGenerator().impactOccurred()
            let editorViewController = EditorViewController()
            //: image container view
            switch GlobalConstants.canvasType
            {
                case 916:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 1)
                case 45:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 2)
                case 11:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 3)
                default:
                    self.currentEmptyCanvasItem = Template.generateEmptyCanvas(with: 1)
            }
            editorViewController.template = self.currentEmptyCanvasItem
            self.presentInFullScreen(editorViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
}











//MARK: - junk
//let cameraViewController = ZLCustomCamera()
//
//
//             ZLPhotoConfiguration.default()
//                 .editImageClipRatios([.custom, .circle, .wh1x1, .wh3x4, .wh16x9, .wh2x3, .wh4x3, .wh9x16, ZLImageClipRatio(title: "2 : 1", whRatio: 2 / 1)])
//     //            .filters([.normal, .process, ZLFilter(name: "custom", applier: ZLCustomFilter.hazeRemovalFilter)])
//                 .imageStickerContainerView(ImageStickerContainerView())
//                 .navCancelButtonStyle(.image)
//                 // You can first determine whether the asset is allowed to be selected.
//                 .hudStyle(.light)
//                 .canSelectAsset { asset in
//                     return true
//                 }
//                 .noAuthorityCallback { type in
//                     switch type {
//                         case .library:
//                             debugPrint("No library authority")
//                         case .camera:
//                             debugPrint("No camera authority")
//                         case .microphone:
//                             debugPrint("No microphone authority")
//                     }
//                 }
//
//             cameraViewController.cancelBlock = {
//                 DispatchQueue.main.async {
//                     self.tabBarController?.selectedIndex = 0
//                     GlobalConstants.isCameraShown = false
//                 }
//             }
//
//             cameraViewController.takeDoneBlock = { (image, localImageUrl) in
//                 guard let editedImage = image else { return }
//
//                 self.editedImage = editedImage
//
//                 self.doneButtonObserver()
//             }
//
//             if !GlobalConstants.isCameraShown
//             {
//                 self.present(cameraViewController, animated: true, completion: nil)
//             }
//             else
//             {
//                 DispatchQueue.main.async {
//                     self.tabBarController?.selectedIndex = 0
//                     GlobalConstants.isCameraShown = true
//                 }
//             }
//
//
//             let editViewController = ZLEditImageViewController(image: UIImage(named: "nature")!)
//
//             editViewController.removeBackgroundBlock = { (image) in
//
//                 guard let newImage = image.removedBg() else { return }
//
//                 print("imageView = ", newImage)
//
//                 editViewController.removedBackGroundBlock?(newImage)
//             }
