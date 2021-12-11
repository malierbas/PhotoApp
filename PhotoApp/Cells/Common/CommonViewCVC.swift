//
//  CommonViewCVC.swift
//  PhotoApp
//
//  Created by Ali on 10.12.2021.
//

import UIKit

class CommonViewCVC: UICollectionViewCell {
    
    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var miniFavImage: UIImageView!
    
    var data: Template? {
        didSet
        {
            setup()
        }
    }
    
    func setup() {
        DispatchQueue.main.async {
            guard let data = self.data else { return }
            self.contentImage.image = data.templateCoverImage
            self.contentImage.layer.cornerRadius = 8
            
            self.contentImage.isHidden = data.isFree ?? false
        }
    }
}
