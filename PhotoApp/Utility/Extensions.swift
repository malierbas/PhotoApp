//
//  Extensions.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit

//MARK: - UIImageView
extension UIImage {
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self

        UIGraphicsBeginImageContext(size)


        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)

        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}

//MARK: - ViewController
extension UIViewController {
    
    //Get controller with animation
    func showViewController(storyboardName: String, viewController: String) {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: viewController)

        window.rootViewController = vc

        let options: UIView.AnimationOptions = .transitionCrossDissolve

        let duration: TimeInterval = 0.3

        UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
        { completed in
            // maybe do something on completion here
        })
    }
}

//MARK: - View
extension UIView {
    //Add shadow and radius
    func addShadowWithRadius(cornerRadius: CGFloat) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
    }
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    // Shadow 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
     }

     // Shadow 2
     func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
         layer.masksToBounds = false
         layer.shadowColor = color.cgColor
         layer.shadowOpacity = opacity
         layer.shadowOffset = offSet
         layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
         layer.shouldRasterize = true
         layer.cornerRadius = self.layer.cornerRadius
         layer.rasterizationScale = scale ? UIScreen.main.scale : 1
     }
    
    //Apply corner radius shadow
    func applyCornerRadiusShadow(with cornerRadius: CGFloat) {
        //viewContainer is the parent of viewContents
        //viewContents contains all the UI which you want to show actually.
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        let bezierPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 12.69)
        self.layer.shadowPath = bezierPath.cgPath
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize.init(width: 0, height: 3)
        self.layer.shadowOpacity = 0.3
        
        // sending viewContainer color to the viewContents.
        let backgroundCGColor = self.backgroundColor?.cgColor
        //You can set your color directly if you want by using below two lines. In my case I'm copying the color.
        self.layer.backgroundColor =  backgroundCGColor
    }

    //round corners
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    //Add gradient
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    //For animating
    func fadeIn() {
        UIView.animate(withDuration: 0.35) {
            self.alpha = 1
        } completion: { boolean in
            if self.isHidden {
                self.isHidden = false
            }
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.35) {
            self.alpha = 0
        } completion: { boolean in
            if !self.isHidden {
                self.isHidden = true
            }
        }
    }
    
    func fadeOutWithAlphaComponent(alpha: CGFloat) {
        UIView.animate(withDuration: 0.35) {
            self.alpha = alpha
        } completion: { boolean in
            if !self.isHidden {
                self.isHidden = true
            }
        }
    }
}

//MARK: - UIColor
extension UIColor {
    func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


//MARK: - Tabbar
extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 74
        return sizeThatFits
    }
}
