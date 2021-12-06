//
//  Cell+ZLPhotoBrowser.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit

extension UICollectionViewCell {
    
    class func zl_identifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    class func zl_register(_ collectionView: UICollectionView) {
        collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: self.zl_identifier())
    }
    
}

extension UITableViewCell {
    
    class func zl_identifier() -> String {
        return NSStringFromClass(self.classForCoder())
    }
    
    class func zl_register(_ tableView: UITableView) {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: self.zl_identifier())
    }
    
}

