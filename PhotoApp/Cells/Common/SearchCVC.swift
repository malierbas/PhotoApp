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
    var itemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sailec-Bold", size: 12)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var itemImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //Variables
    
    //LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(itemImageView)
        itemImageView.setWidth(size: 159)
        itemImageView.setHeight(size: 183)
        itemImageView.pinToTop()
        itemImageView.pinToBottom()
        itemImageView.equalsToLeadings()
        itemImageView.equalsToTrailings()
        itemImageView.layer.cornerRadius = 12
        
        self.addSubview(itemDescriptionLabel)
        itemDescriptionLabel.pinToBottom(with: -16)
        itemDescriptionLabel.centerXToSuperView(with: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
