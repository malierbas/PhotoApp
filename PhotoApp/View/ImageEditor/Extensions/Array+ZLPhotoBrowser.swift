//
//  Array+ZLPhotoBrowser.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
// 

import Foundation

extension Array where Element: Equatable {
    
    func removeDuplicate() -> Array {
        return self.enumerated().filter { (index, value) -> Bool in
            return self.firstIndex(of: value) == index
        }.map { (_, value) in
            return value
        }
    }
    
}

