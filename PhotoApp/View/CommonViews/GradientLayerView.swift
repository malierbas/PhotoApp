//
//  GradientLayerView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class GradientLayerView: UIView {

    var colors: [UIColor] = [.clear, .black]
    var locations: [NSNumber]?
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)

    init(colors: [UIColor] = [.clear, .black], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.locations = locations
        super.init(frame: .zero)
        prepareUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        prepareUI()
    }

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }

    private func prepareUI() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = self.colors.map({ $0.cgColor })
        gradientLayer.locations = self.locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
