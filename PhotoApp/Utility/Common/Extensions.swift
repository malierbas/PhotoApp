//
//  Extensions.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit
import CoreML
import Vision
import VideoToolbox

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
    
    //: Show alert
    func showAlertWith(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    //: Present in full screen
    @objc func presentInFullScreen(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
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

//MARK: - UIView Constraints
extension UIView {
    //constraints
    func equalsToWidth() {
        guard let superView = superview else { return }
        self.widthAnchor.constraint(equalToConstant: superView.frame.width).isActive = true
    }
    
    func equalsToHeight() {
        guard let superView = superview else { return }
        self.heightAnchor.constraint(equalToConstant: superView.frame.height).isActive = true
    }
    
    func setWidth(size: CGFloat?) {
        guard let width = size else { return }
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(size: CGFloat?) {
        guard let height = size else { return }
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func centerXToSuperView(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }

        self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: size).isActive = true
    }
    
    func centerYToSuperView() {
        guard let superView = superview else { return }
        self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: 0).isActive = true
    }
    
    func pinToTop() {
        guard let superView = superview else { return }
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
    }
    
    func pinTopToBottom(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }

        self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: size).isActive = true
    }

    func pinToBottom() {
        guard let superView = superview else { return }
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
    func pinToBottom(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: size).isActive = true
    }
    
    func pinToTopWithSize(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: size).isActive = true
    }
    
    func pinToBottomWithSize(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: size).isActive = true
    }
    
    func equalsToLeadings() {
        guard let superView = superview else { return }
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
    }
    
    func equalsToTrailings() {
        guard let superView = superview else { return }
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
    
    func equalsToLeadings(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: size).isActive = true
    }
    
    func equalsToTrailings(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: size).isActive = true
    }
    
    func equalsToTrailingWithView(view: UIView?) {
        guard let view = view else { return }
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func equalsToTrailingWithView(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: size).isActive = true
    }
    
    func equalsToLeadingWithView(view: UIView?) {
        guard let view = view else { return }
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func equalsToLeadingWithView(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: size).isActive = true
    }
    
    func equalsLeadingToTrailing(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }
        self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: size).isActive = true
    }
}

//MARK: - Remove Background
extension UIImage {
    //: Remove Background
    func removedBg() -> UIImage? {
        let model = DeepLabV3()
        let context = CIContext(options: nil)
        
        let width: CGFloat = 513
        let height: CGFloat = 513
        // CoreMLHelpers -> UIImage+Extensions.swift
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        
        // CoreMLHelpers -> UIImage+CVPixelBuffer.swift
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer),
        // CoreMLHelpers -> MLMultiArray+Image
        let outputImage = outputPredictionImage.semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1)),
        let outputCIImage = CIImage(image: outputImage),
        // CIImage extension helper method
        let maskImage = outputCIImage.removeWhitePixels(),
        // (Optional) Blur image a bit if you want to avoid sharpness
        let maskBlurImage = maskImage.applyBlurEffect() else { return nil }

        // After we got a masked background image, resize it to the original size
        return UIImage(
            ciImage: maskBlurImage,
            scale: scale,
            orientation: self.imageOrientation
        ).resized(to: CGSize(width: size.width, height: size.height))
    }
    
//    private func removeBackground(image:UIImage) -> UIImage?{
//        let resizedImage = image.resized(to: CGSize(width: 513, height: 513))
//        if let pixelBuffer = resizedImage.pixelBuffer(width: Int(resizedImage.size.width), height: Int(resizedImage.size.height)){
//            if let outputImage = (try? model.prediction(image: pixelBuffer))?.semanticPredictions.image(min: 0, max: 1, axes: (0,0,1)), let outputCIImage = CIImage(image:outputImage){
//                if let maskImage = removeWhitePixels(image:outputCIImage), let resizedCIImage = CIImage(image: resizedImage), let compositedImage = composite(image: resizedCIImage, mask: maskImage){
//                    return UIImage(ciImage: compositedImage).resized(to: CGSize(width: image.size.width, height: image.size.height))
//                }
//            }
//        }
//        return nil
//    }
    
    //: Get Model
    private func getDeepLabV3Model() -> DeepLabV3? {
        do {
            let config = MLModelConfiguration()
            return try DeepLabV3(configuration: config)
        } catch {
            print("Error loading model: \(error)")
            return nil
        }
    }
}

extension CIImage {

    func removeWhitePixels() -> CIImage? {
        let chromaCIFilter = chromaKeyFilter()
        chromaCIFilter?.setValue(self, forKey: kCIInputImageKey)
        return chromaCIFilter?.outputImage
    }

    func composite(with mask: CIImage) -> CIImage? {
        return CIFilter(
            name: "CISourceOutCompositing",
            parameters: [
                kCIInputImageKey: self,
                kCIInputBackgroundImageKey: mask
            ]
        )?.outputImage
    }

    func applyBlurEffect() -> CIImage? {
        let context = CIContext(options: nil)
        let clampFilter = CIFilter(name: "CIAffineClamp")!
        clampFilter.setDefaults()
        clampFilter.setValue(self, forKey: kCIInputImageKey)

        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        currentFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
        currentFilter.setValue(2, forKey: "inputRadius")
        guard let output = currentFilter.outputImage,
              let cgimg = context.createCGImage(output, from: extent) else { return nil }

        return CIImage(cgImage: cgimg)
    }

    private func chromaKeyFilter() -> CIFilter? {
        let size = 64
        var cubeRGB = [Float]()

        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size - 1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size - 1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size - 1)
                    let brightness = getBrightness(red: red, green: green, blue: blue)
                    let alpha: CGFloat = brightness == 1 ? 0 : 1
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }

        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))

        let colorCubeFilter = CIFilter(
            name: "CIColorCube",
            parameters: [
                "inputCubeDimension": size,
                "inputCubeData": data
            ]
        )
        return colorCubeFilter
    }

    private func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var brightness: CGFloat = 0
        color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}
