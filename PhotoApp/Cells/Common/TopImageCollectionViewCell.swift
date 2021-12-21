//
//  TopImageCollectionViewCell.swift
//  PhotoApp
//
//  Created by Ali on 20.12.2021.
//

import UIKit

class TopImageCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    //: view
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 223, height: 338))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: - Setup View
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        addSubview(imageView)
        setupLayout()
    }
    
    private func setupLayout() {
        imageView.fillSuperview()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
