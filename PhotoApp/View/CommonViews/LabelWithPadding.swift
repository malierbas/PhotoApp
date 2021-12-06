//
//  LabelWithPadding.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class LabelWithPadding: UILabel {

    @objc var padding = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    init() {
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: padding)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -padding.top,
                                          left: -padding.left,
                                          bottom: -padding.bottom,
                                          right: -padding.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    //    override var intrinsicContentSize: CGSize {
    //        var superSize = super.intrinsicContentSize
    //        superSize.height += self.padding.top + self.padding.bottom
    //        superSize.width += self.padding.left + self.padding.right
    //        return superSize
    //    }
}

