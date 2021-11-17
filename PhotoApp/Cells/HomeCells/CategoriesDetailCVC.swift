//
//  CategoriesDetailCVC.swift
//  PhotoApp
//
//  Created by Ali on 17.11.2021.
//

import UIKit

class CategoriesDetailCVC: UICollectionViewCell {
    
    var itemImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }() {
        didSet {
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(itemImageView)
        itemImageView.pinToTop()
        itemImageView.pinToBottom()
        itemImageView.equalsToLeadings()
        itemImageView.equalsToTrailings()
        itemImageView.layer.cornerRadius = 12
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
