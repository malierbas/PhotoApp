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
    @IBOutlet weak var productCount: UILabel!
    
    var data: TrendingCategoriesModel! {
        didSet {
            setupView()
        }
    }
    
    //MARK: - SetupView
    func setupView() {
        DispatchQueue.main.async { [self] in
            tag = data.id!
            
            self.backgroundGradientView.layerGradient(color1Hex: data.backgrodundColors!.first!, color2Hex: data.backgrodundColors!.last!)
            
            self.backgroundGradientView.layer.cornerRadius = 8
            
            self.dropShadow()
            
            self.iconImageView.image = UIImage(named: data.icon!)
            
            self.productName.text = data.categoryName!
            self.productCount.text = "\(data.filterCount!) photos"
        }
    }
}
