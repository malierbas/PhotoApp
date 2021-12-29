//
//  PaywallViewController.swift
//  PhotoApp
//
//  Created by Ali on 16.12.2021.
//

import UIKit

class PaywallViewController: BaseVC {
    //MARK: - Properties
    //: view
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var descTextStackView: UIStackView!
    @IBOutlet weak var backButton: UIImageView!
    @IBOutlet weak var purchaseItemsTableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    //: constraints
    @IBOutlet weak var tableViewHeightConstraints: NSLayoutConstraint!
    
    //: variables
    var imageName = "whiteCheckmark"
    var descText = [
        "Lorem ipsum dolor sit amet.",
        "Nullam inderdum maecenas accumsan.",
        "Non lectus donec elit vitae.",
        "Vestibulum in lectus vitae vel"
    ]
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            //: view corners
            self.bottomView.layer.cornerRadius = 40
            
            //: tableView
            self.purchaseItemsTableView.delegate = self
            self.purchaseItemsTableView.dataSource =  self
            self.purchaseItemsTableView.reloadData()
            self.purchaseItemsTableView.isScrollEnabled = false
            
            //: continue button
            self.continueButton.layer.cornerRadius = self.continueButton.frame.height / 2
            
            //: setup description text
            self.setupDescriptionText()
            
            //: back button
            self.backButton.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.backButtonAction))
            self.backButton.addGestureRecognizer(gesture)
            
            //: constraints
            self.tableViewHeightConstraints.constant = 140
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
    }
    
    //MARK: - Public Functions
    func setupDescriptionText() {
        DispatchQueue.main.async {
            
            for label in self.createAims()
            {
                self.descTextStackView.addArrangedSubview(label)
            }
        }
    }
    
    //MARK: -CreateLabelWithImage
   func createAims() -> [UILabel] {
       //Label & Flag
       var mainAims = [UILabel]()
       
       //Create Archieve Array
       for item in self.descText {
           let desctiption = item
           let label = createBodyLabelWithImage(with: self.imageName, and: desctiption)
           mainAims.append(label)
       }
        
       return mainAims
   }
   
   func createBodyLabelWithImage(with flag: String, and aimTitle: String) -> UILabel {
       let mainLabel = UILabel()
       // Create Attachment
       let imageAttachment = NSTextAttachment()
       imageAttachment.image = UIImage(named: flag)
       // Set bound to reposition
       imageAttachment.bounds = CGRect(x: 0, y: 0, width: imageAttachment.image!.size.width / 1.3, height: imageAttachment.image!.size.height / 1.3)
       // Create string with attachment
       let attachmentString = NSAttributedString(attachment: imageAttachment)
       // Initialize mutable string
       let completeText = NSMutableAttributedString(string: "")
       // Add image to mutable string
       completeText.append(attachmentString)
       // Add your text to mutable string
       let textAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 14)]
       let textAfterIcon1 = NSAttributedString(string: "  ")
       let textAfterIcon = NSAttributedString(string: aimTitle, attributes: textAttributes as [NSAttributedString.Key : Any])
       let labelOffsetY: CGFloat =  -8.0
       mainLabel.bounds = CGRect(x: 0, y: labelOffsetY, width: imageAttachment.image!.size.width / 2, height: imageAttachment.image!.size.height / 2)
       completeText.append(textAfterIcon1)
       completeText.append(textAfterIcon)
       mainLabel.attributedText = completeText
       mainLabel.textColor = .white
       return mainLabel
   }
    
    //MARK: - Actions
    @objc func backButtonAction() {
        self.dismiss(animated: true) {
            //: do something
        }
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        LocalStorageManager.shared.isPremiumUser = true
    }
}


extension PaywallViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaywallTableViewCell", for: indexPath) as! PaywallTableViewCell
        
        cell.freeView.layer.cornerRadius = cell.freeView.frame.height / 2
        cell.hideSelectionColor()
        if indexPath.row == 0
        {
            cell.cellSelected = true
        }
        else
        {
            cell.cellSelected = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            guard let cell = tableView.cellForRow(at: indexPath) as? PaywallTableViewCell else { return }
            for item in self.purchaseItemsTableView.visibleCells
            {
                guard let firstCell = item as? PaywallTableViewCell else { return }
                
                if cell == firstCell
                {
                    //: selected
                    cell.cellSelected = true
                }
                else
                {
                    //: unselected
                    firstCell.cellSelected = false
                }
            }
        }
    }
}
