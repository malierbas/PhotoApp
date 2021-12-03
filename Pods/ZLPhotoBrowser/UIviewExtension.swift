//
//  UIviewExtension.swift
//  ZLPhotoBrowser
//
//  Created by Ali on 28.11.2021.
//

import Foundation
import CoreML
import UIKit

//MARK: - Remove Background
@available(iOS 12.0, *)
extension UIImage {
    //: Remove Background
    func removedBg() -> UIImage? {
        let model = DeepLabV3()
        let context = CIContext(options: nil)
        
        let width: CGFloat = 513
        let height: CGFloat = 513
        // CoreMLHelpers -> UIImage+Extensions.swift
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        
        guard let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
        let outputPredictionImage = try? model.prediction(image: pixelBuffer),
        // CoreMLHelpers -> MLMultiArray+Image
        let outputImage = outputPredictionImage.semanticPredictions.image(min: 0, max: 1, axes: (0, 0, 1)),
        let outputCIImage = CIImage(image: outputImage),
        // CIImage extension helper method
        let maskImage = outputCIImage.removeWhitePixels(),
        let resizedCIImage = CIImage(image: resizedImage),
        // (Optional) Blur image a bit if you want to avoid sharpness
        let maskBlurImage = maskImage.applyBlurEffect() else { return nil }

        // After we get a final background image we are going to use it as a mask for composing with the resized image.
        guard let compositedImage = resizedCIImage.composite(with: maskBlurImage) else { return nil }
        return UIImage(ciImage: compositedImage)
            .resized(to: CGSize(width: size.width, height: size.height))
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

//MARK: - CIImage
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


extension CALayer {
    func applyCornerRadiusShadow(
        color: UIColor             = .black,
        alpha: Float               = 0.5,
        x: CGFloat                 = 0,
        y: CGFloat                 = 2,
        blur: CGFloat              = 4,
        spread: CGFloat            = 0,
        cornerRadiusValue: CGFloat = 12)
    {
        cornerRadius  = cornerRadiusValue
        shadowColor   = color.cgColor
        shadowOpacity = alpha
        shadowOffset  = CGSize(width: x, height: y)
        shadowRadius  = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx     = -spread
            let rect   = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

