//
//  AllHighlightSecondCVC.swift
//  PhotoApp
//
//  Created by Ali on 16.12.2021.
//

import UIKit

class AllHighlightSecondCVC: UICollectionViewCell {
    //MARK: - Properties
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    //MARK: - Data
    var data: Template! {
        didSet {
            setupView()
        }
    }
    
    //MARK: - Setup
    func setupView() {
        DispatchQueue.main.async {
            self.categoryImageView.image = self.data.templateCoverImage
            self.makeCircle()
        }
    }
}
