//
//  PaywallTableViewCell.swift
//  PhotoApp
//
//  Created by Ali on 26.12.2021.
//

import UIKit

class PaywallTableViewCell: UITableViewCell {
    //MARK: - Properties
    //: views
    @IBOutlet weak var selectionBGView: UIView!
    @IBOutlet weak var checkedView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var freeView: UIView!
    @IBOutlet weak var freeDescView: UILabel!
    
    //: variables
    var cellSelected: Bool!
    {
        didSet
        {
            if cellSelected
            {
                addSelectedBorder()
            }
            else
            {
                removeSelectedBorder()
            }
        }
    }

    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionBGView.layer.cornerRadius = self.selectionBGView.frame.height / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Setup
    //: selected
    func addSelectedBorder() {
        DispatchQueue.main.async {
            guard let checkedImage = UIImage(named: "checked1") else { return}
            self.checkedView.image = checkedImage
            self.selectionBGView.layer.borderWidth = 1
            self.freeView.isHidden = false
            self.selectionBGView.layer.borderColor = UIColor.init(named: "SelectionBorderColor")?.cgColor ?? UIColor.gray.withAlphaComponent(0.45).cgColor
        }
    }
    
    //: unselected
    func removeSelectedBorder() {
        DispatchQueue.main.async {
            guard let uncheckedImage = UIImage(named: "unchecked") else { return}
            self.checkedView.image = uncheckedImage
            self.selectionBGView.layer.borderWidth = 0
            self.freeView.isHidden = true
            self.selectionBGView.layer.borderColor = UIColor.init(named: "SelectionBorderColor")?.cgColor ?? UIColor.gray.withAlphaComponent(0.45).cgColor
        }
    }
}
