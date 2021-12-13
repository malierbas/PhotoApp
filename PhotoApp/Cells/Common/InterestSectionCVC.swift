//
//  InterestSectionCVC.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit

class InterestSectionCVC: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var template : Template! {
        didSet {
            setupView()
        }
    }
    
    func setupView() {
        DispatchQueue.main.async { [self] in
            photoImageView.image = template.templateCoverImage
            photoImageView.fillSuperview()
            
            self.photoImageView.backgroundColor = UIColor(hex: "#685C52")
            
            contentView.clipsToBounds = true
            self.layer.cornerRadius = 12
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        photoImageView.frame = contentView.bounds
    }
}
