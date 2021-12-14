//
//  TrendingCategoriesCVC.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit

class TrendingCategoriesCVC: UICollectionViewCell {
    //MARK: - Iboutlets
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    
    var data: Template! {
        didSet {
            setupView()
        }
    }
    
    //MARK: - SetupView
    func setupView() {
        DispatchQueue.main.async { [self] in
        
            self.backgroundGradientView.backgroundColor = .clear
            
            self.iconImageView.image = data.templateCoverImage
            
            self.iconImageView.layer.cornerRadius = 8
            
            guard let canvasText = data.canvasTexts else { return }
            
//            self.productName.text = canvasText.count != 0 ? canvasText.first?.text : "Category item"
        }
    }
}
