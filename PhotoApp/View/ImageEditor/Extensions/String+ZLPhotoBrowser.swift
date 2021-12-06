//
//  String+ZLPhotoBrowser.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import Foundation
import UIKit

extension String {
    
    func boundingRect(font: UIFont, limitSize: CGSize) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        
        let att = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        
        let attContent = NSMutableAttributedString(string: self, attributes: att)
        
        let size = attContent.boundingRect(with: limitSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
}
