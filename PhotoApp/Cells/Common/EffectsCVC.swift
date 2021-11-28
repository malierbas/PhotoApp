//
//  EffectsCVC.swift
//  PhotoApp
//
//  Created by Ali on 20.11.2021.
//

import UIKit

class EffectsCVC: UICollectionViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var itemsContainerView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    
    var data: SuggestionsModel! {
        didSet {
            self.updateCell()
        }
    }
    
    private func updateCell() {
        DispatchQueue.main.async {
            self.itemImageView.layer.cornerRadius = 12
            self.itemImageView.image = UIImage(named: self.data.itemImage ?? "")
            
            self.itemDescriptionLabel.text = self.data.itemName ?? ""
        }
    }
}
