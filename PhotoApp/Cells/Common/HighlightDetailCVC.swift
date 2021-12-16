//
//  HighlightDetailCVC.swift
//  PhotoApp
//
//  Created by Ali on 16.12.2021.
//

import UIKit

class HighlightDetailCVC: UICollectionViewCell {
    //MARK: - Properties
    @IBOutlet weak var mainBGView: UIView!
    
    @IBOutlet weak var contentImageView: UIImageView!
    //MARK: - data
    var data: Template?
    {
        didSet
        {
            setupView()
        }
    }
    
    //MARK: - setup
    func setupView() {
        DispatchQueue.main.async {
            self.makeCircle()
            guard let image = self.data?.templateCoverImage else { return }
            self.contentImageView.image = image
        }
    }
}
