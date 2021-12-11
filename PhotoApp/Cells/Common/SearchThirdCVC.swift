//
//  SearchThirdCVC.swift
//  PhotoApp
//
//  Created by Ali on 10.12.2021.
//

import UIKit

class SearchThirdCVC: UICollectionViewCell {
    //MARK: - Properties
    //Views
    @IBOutlet weak var itemImageView: UIImageView!
    
    //Variables
    var data: Template? {
        didSet {
            self.setupView()
        }
    }
    
    //: setup view
    func setupView() {
        DispatchQueue.main.async {
            guard let data = self.data else { return }
            self.itemImageView.image = data.background?.image
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
}
