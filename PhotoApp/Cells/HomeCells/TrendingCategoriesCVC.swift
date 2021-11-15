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
        
            self.backgroundGradientView.backgroundColor = .clear
           
            let startColor = UIColor().hexStringToUIColor(hex: data.backgrodundColors?.first ?? "")
            let endColor = UIColor().hexStringToUIColor(hex: data.backgrodundColors?.last ?? "")
            
            self.applyGradient(colours: [startColor, endColor]).cornerRadius = 10
            
            self.iconImageView.image = UIImage(named: data.icon!)
            
            self.productName.text = data.categoryName!
            
            self.productCount.text = "\(data.filterCount!) photos"
        }
    }
}
