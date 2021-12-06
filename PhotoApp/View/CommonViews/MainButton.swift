//
//  MainButton.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

enum MainButtonStyle {
    case ghost(tintColor: UIColor)
    case filledBackground(tintColor: UIColor)
    case gradientBackground
}

class MainButton: UIButton {
    
    var style: MainButtonStyle?
    
    var leftIconImage: UIImage? {
        didSet {
            guard let leftIconImage = leftIconImage else { return }
            setImage(leftIconImage, for: .normal)
            imageEdgeInsets = .init(rightPadding: 5)
            titleEdgeInsets = .init(leftPadding: 5)
        }
    }
    
    convenience init(style: MainButtonStyle) {
        self.init(type: .system)
        self.style = style
        switch style {
        case .ghost(let tintColor):
            self.tintColor = tintColor
        case .filledBackground(let tintColor):
            self.tintColor = tintColor
        default:
            break
        }
        setupLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let style = style else { return }
        switch style {
        case .ghost(let tintColor):
            self.tintColor = tintColor
        case .filledBackground(let tintColor):
            self.tintColor = tintColor
        default:
            break
        }
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    
    func setupLayout() {
        contentMode = .scaleAspectFit
        guard let style = style else { return }
        switch style {
        case .ghost:
            self.backgroundColor = .clear
            // enable customizing borderColor if set other than tint color
            self.layer.borderColor = self.layer.borderColor == UIColor.black.cgColor ? tintColor.cgColor : self.layer.borderColor
            self.layer.borderWidth = 1.0
            self.setTitleColor(tintColor, for: .normal)
        case .gradientBackground:
            // set background gradient
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = [UIColor(hexString: "#02D5FF").cgColor, UIColor(hexString: "#0099FF").cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.insertSublayer(gradientLayer, at: 0)
            self.setTitleColor(.white, for: .normal)
        case .filledBackground:
            self.backgroundColor = tintColor
            self.setTitleColor(.white, for: .normal)
        }
        
        if layer.cornerRadius == 0 {
            layer.cornerRadius = bounds.size.height / 2.0
        }
        layer.masksToBounds = true
    }
}

