//
//  ZLAddPhotoCell.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import Foundation
import UIKit

class ZLAddPhotoCell: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    deinit {
        zl_debugPrint("ZLAddPhotoCell deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width / 3, height: self.bounds.width / 3)
        self.imageView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        
    }
    
    func setupUI() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = ZLPhotoConfiguration.default().cellCornerRadio
        
        self.imageView = UIImageView(image: getImage("zl_addPhoto"))
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
        self.backgroundColor = .cameraCellBgColor
    }
}

