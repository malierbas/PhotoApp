//
//  Sticker.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class Sticker {
    var image: UIImage?
    var isFree: Bool = true
    var latestCenter: CGPoint = .zero

    init(image: UIImage?, isFree: Bool = true) {
        self.image = image
        self.isFree = isFree
    }
}

