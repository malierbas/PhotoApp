//
//  Background.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class Background {
    var name: String?
    var color: UIColor?
    var image: UIImage?
    var preview: UIImage?
    var gradientLayerView: GradientLayerView?
    var isFree: Bool = true
    var type: BackgroundType?

    init(color: UIColor? = nil, image: UIImage? = nil, preview: UIImage? = nil, isFree: Bool = true, name: String? = nil, type: BackgroundType? = .pattern, gradientLayerView: GradientLayerView? = nil) {
        self.color = color
        self.image = image
        self.isFree = isFree
        self.name = name
        self.preview = preview
        self.type = type
        self.gradientLayerView = gradientLayerView
    }
}

