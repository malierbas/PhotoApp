//
//  SeeAllCategoriesCVC.swift
//  PhotoApp
//
//  Created by Ali on 10.12.2021.
//

import UIKit

class SeeAllCategoriesCVC: UICollectionViewCell {
    //MARK: - Properties
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
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
            self.categoryImageView.layer.cornerRadius = 12
            
            guard let canvasText = self.data.canvasTexts else { return }
            
            self.productName.text = canvasText.count != 0 ? canvasText.first?.text : "Category item"
        }
    }
}
