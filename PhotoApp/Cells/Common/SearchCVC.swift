//
//  SearchCVC.swift
//  PhotoApp
//
//  Created by Ali on 20.11.2021.
//

import UIKit

class SearchCVC: UICollectionViewCell {
    //MARK: - Properties
    //Views
    @IBOutlet weak var itemImageView: UIImageView!
    
    //Variables
    var data: Template? {
        didSet {
            setup()
        }
    }
    
    //: setup view
    func setup() {
        DispatchQueue.main.async {
            guard let data = self.data else { return }
            self.itemImageView.image = data.templateCoverImage
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
}
