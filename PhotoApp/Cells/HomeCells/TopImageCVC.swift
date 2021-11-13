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
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productOwnerName: UILabel!
    
    var data: TopImageModel! {
        didSet {
            setupView()
        }
    }
    
    //MARK: - SetupView
    func setupView() {
        DispatchQueue.main.async { [self] in
            tag = data.id!
            
            self.contentItemsView.layer.cornerRadius = 14
            
            self.dropShadow()
            
            rozetView.isHidden = data.isFavourite! ? false : true
            
            productName.text = data.productName!
            
            productOwnerName.text = data.productOwner!
        }
    }
}
