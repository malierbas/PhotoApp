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

extension UILabel {
    func heightForLabel(width:CGFloat) -> CGFloat {
        self.frame = CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude)
        sizeToFit()
        return frame.height
    }
}

func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    
    return label.frame.height
}

extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

//MARK: - View
extension UIView {
    
    //: all subview
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
    
    //: Shake direction
    enum ShakeDirection {
        case vertical
        case horizontal
    }
    
    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, completion:(() -> Void)? = nil) {
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
    
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

    func asImage2() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { ctx in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }

    func asImage3() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
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
    
    func applyGradient(with colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(with colours: [UIColor], gradient orientation: GradientOrientation) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
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
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    /// Constructing color from hex string
    ///
    /// - Parameter hex: A hex string, can either contain # or not
    convenience init(hex string: String) {
        var hex = string.hasPrefix("#")
            ? String(string.dropFirst())
            : string
        guard hex.count == 3 || hex.count == 6
            else {
                self.init(white: 1.0, alpha: 0.0)
                return
        }
        if hex.count == 3 {
            for (index, char) in hex.enumerated() {
                hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
            }
        }

        self.init(
            red:   CGFloat((Int(hex, radix: 16)! >> 16) & 0xFF) / 255.0,
            green: CGFloat((Int(hex, radix: 16)! >> 8) & 0xFF) / 255.0,
            blue:  CGFloat((Int(hex, radix: 16)!) & 0xFF) / 255.0, alpha: 1.0)
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

//MARK: - UiFont
extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: self],
            context: nil).size
    }
}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint : CGPoint {
        return points.startPoint
    }
    
    var endPoint : CGPoint {
        return points.endPoint
    }
    
    var points : GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
        case .horizontal:
            return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
        case .vertical:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
        }
    }
}

//MARK: - Ui Edge insets
extension UIEdgeInsets {
    init(topPadding: CGFloat = 0, leftPadding: CGFloat = 0, bottomPadding: CGFloat = 0, rightPadding: CGFloat = 0) {
        self.init(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
    }
}

//MARK: - UIView Constraints
extension UIView {
    //constraints
    func fillToSuperView() {
        guard let superView = superview else { return }
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToWidth() {
        guard let superView = superview else { return }
        self.widthAnchor.constraint(equalToConstant: superView.frame.width).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToHeight() {
        guard let superView = superview else { return }
        self.heightAnchor.constraint(equalToConstant: superView.frame.height).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setWidth(size: CGFloat?) {
        guard let width = size else { return }
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setHeight(size: CGFloat?) {
        guard let height = size else { return }
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func centerXToSuperView(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }

        self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func centerYToSuperView() {
        guard let superView = superview else { return }
        self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: 0).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinToTop() {
        guard let superView = superview else { return }
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinTopToBottom(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }

        self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func pinToBottom() {
        guard let superView = superview else { return }
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinToBottom(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinToTopWithSize(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func pinToBottomWithSize(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToLeadings() {
        guard let superView = superview else { return }
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToTrailings() {
        guard let superView = superview else { return }
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToLeadings(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToTrailings(with size: CGFloat?) {
        guard let superView = superview else { return }
        guard let size = size else { return }
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToTrailingWithView(view: UIView?) {
        guard let view = view else { return }
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToTrailingWithView(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToLeadingWithView(view: UIView?) {
        guard let view = view else { return }
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsToLeadingWithView(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func equalsLeadingToTrailing(view: UIView?, with size: CGFloat?) {
        guard let view = view else { return }
        guard let size = size else { return }
        self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: size).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, padding: UIEdgeInsets = .zero) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
    }
    
    func fillSuperview(withPadding padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding.left).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -padding.right).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom).isActive = true
        }
    }
    
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    func addSubviews(views: UIView...) {
        views.forEach({ self.addSubview($0)} )
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

extension UINavigationController {
    open override var prefersStatusBarHidden: Bool {
        return self.topViewController?.prefersStatusBarHidden ?? false
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .lightContent
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.topViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
}

extension UITabBarController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .lightContent
    }

    open override var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return self.selectedViewController?.preferredStatusBarUpdateAnimation ?? .none
    }
}

extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
}


extension UIButton {
    func startShimmering(animationDuration: Float = 1,
                         delay: Float = 1,
                         startPoint: CGPoint = CGPoint(x: 0, y: 0.45),
                         endPoint: CGPoint = CGPoint(x: 1, y: 0.55),
                         repeatCount: Float = MAXFLOAT) {

        // Create color  -> 1
        let lightColor = UIColor.lightGray.cgColor
        let darkColor = UIColor.white.cgColor

        // Create a CAGradientLayer  -> 2
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [darkColor, lightColor, darkColor]
        gradientLayer.frame = self.bounds
        gradientLayer.backgroundColor = UIColor.clear.cgColor


        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.locations =  [0.2, 0.5, 0.8] //[0.4, 0.6]
        self.layer.mask = gradientLayer

        // Add animation over gradient Layer -> 3
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.4, -0.2, 0]
        animation.toValue = [1.0, 1.2, 1.4]
        animation.duration = CFTimeInterval(animationDuration)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation]
        groupAnimation.duration = CFTimeInterval(animationDuration + delay)
        groupAnimation.repeatCount = repeatCount
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false

        CATransaction.setCompletionBlock { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.layer.mask = nil
        }
        gradientLayer.add(groupAnimation, forKey: "shimmerAnimation")
        CATransaction.commit()
    }
}

public extension UIView {

    @discardableResult
    func addBlur(style: UIBlurEffect.Style = .extraLight) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        addSubview(blurBackground)
        blurBackground.fillSuperview()
        return blurBackground
    }
}

extension Data {
    func convertToDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

extension UIButton {
    func startPulsing() {

        // scale pulse
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0.94
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude

        layer.add(pulseAnimation, forKey: nil)


        // wave scale pulse
        let waveView = UIView(frame: bounds)
        waveView.layer.borderColor = UIColor.white.cgColor
        waveView.layer.borderWidth = 0.5
        waveView.layer.cornerRadius = layer.cornerRadius
        waveView.layer.masksToBounds = false

        let wavePulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        wavePulseAnimation.duration = 2
        wavePulseAnimation.fromValue = 1
        wavePulseAnimation.toValue = 1.5
        wavePulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        wavePulseAnimation.repeatCount = .greatestFiniteMagnitude
        waveView.layer.add(wavePulseAnimation, forKey: nil)


        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        waveView.layer.add(opacityAnimation, forKey: nil)


        layer.addSublayer(waveView.layer)

    }
}

