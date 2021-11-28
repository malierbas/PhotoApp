//
//  InterestSectionCVC.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit

class InterestSectionCVC: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var image : UIImage! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        DispatchQueue.main.async { [self] in
            photoImageView.image = image
            
            contentView.clipsToBounds = true
            
            self.layer.cornerRadius = 14
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.frame = contentView.bounds
    }
}
