//
//  QuotesSecondCVC.swift
//  PhotoApp
//
//  Created by Ali on 11.12.2021.
//

import UIKit

class QuotesSecondCVC: UICollectionViewCell {
    //MARK: - Properties
    @IBOutlet weak var contentImageView: UIImageView!
    
    //MARK: - Data
    var data: Template! {
        didSet
        {
            self.setupView()
        }
    }
    
    //MARK: - Setup
    func setupView() {
        DispatchQueue.main.async {

            guard let data = self.data else { return }
            self.contentImageView.image = data.templateCoverImage
            self.layer.cornerRadius = self.frame.width / 2
        }
    }
}
