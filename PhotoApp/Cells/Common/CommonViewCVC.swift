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
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
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
            self.contentImage.isHidden = data.isFree ?? false
            
            self.mainView.layer.cornerRadius =  12
            self.contentImage.layer.cornerRadius = 12
        }
    }
}
