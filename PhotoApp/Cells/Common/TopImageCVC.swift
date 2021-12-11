//
//  TopImageCVC.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit

class TopImageCVC: UICollectionViewCell {
    //MARK: - Iboutlets
    @IBOutlet weak var contentItemsView: UIView!
    @IBOutlet weak var rozetView: UIImageView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productOwnerName: UILabel!
    @IBOutlet weak var gradiendView: UIImageView!
    
    var data: Template! {
        didSet {
            setupView()
        }
    }
    
    //MARK: - SetupView
    func setupView() {
        DispatchQueue.main.async { [self] in
//            tag = data.id!
            
            self.contentItemsView.layer.cornerRadius = 10
            
            self.productImageView.image = data.templateCoverImage
            self.productImageView.layer.cornerRadius = 10
            self.productImageView.clipsToBounds = true
            
//            self.gradiendView.layer.cornerRadius = 14
            
            self.layer.cornerRadius = 14
            
            
//            self.applyCornerRadiusShadow(with: 14)
            
            rozetView.isHidden = data.isFree! ? false : true
            
//            productName.text = data.productName!
            
//            productOwnerName.text = data.productOwner!
        }
    }
}
