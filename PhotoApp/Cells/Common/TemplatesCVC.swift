//
//  TemplatesCVC.swift
//  PhotoApp
//
//  Created by Ali on 12.12.2021.
//

import UIKit

class TemplatesCVC: UICollectionViewCell {
    //MARK: - Properties
    @IBOutlet weak var templateName: UILabel!
    
    //MARK: - Data
    var data: String? {
        didSet
        {
            setupView()
        }
    }
    
    //MARK: - Setup view
    func setupView() {
        
        DispatchQueue.main.async {
            guard let name = self.data else { return }
            self.templateName.text = name
            self.layer.cornerRadius = self.frame.height / 2
        }
    }
}
