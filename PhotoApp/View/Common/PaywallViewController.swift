//
//  PaywallViewController.swift
//  PhotoApp
//
//  Created by Ali on 16.12.2021.
//

import UIKit
import StoreKit
import Purchases

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
    var subsModel : [SubscriptionModel] = []
    public static var selectedIdentifier = 0
    
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
            
            //: - subscription -
            self.getSubscriptionDetails { isEndWithSuccess in
                print("en with success = ", isEndWithSuccess)
                if isEndWithSuccess
                {
                    //: - do something -
                }
                else
                {
                    //: - do something -
                }
            }
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
    
    //: - subscription -
    func fetchPackage(completion: @escaping (Purchases.Package) -> Void){
        Purchases.shared.offerings { offerings, error in
            guard let offerings = offerings, error == nil else {
                return
            }
            
            guard let package = offerings.all.first?.value.availablePackages.last else {
                return
            }
            completion(package)
        }
    }
    
    func purchase(package: Purchases.Package) {
        Purchases.shared.purchasePackage(package) { transaction, info, error, userCancelled in
            self.view.isUserInteractionEnabled = true
            if userCancelled {
                //: - user canceled -
            }
            
            if let error = error {
                print("purchase error = ", error.localizedDescription)
                //: - an error occured -
                self.view.isUserInteractionEnabled = true
            }
            
            if info?.entitlements.all["Subscriptions"]?.isActive == true {
                DispatchQueue.main.async {
                    
                    
                    
                    
//                    WebService.instance.updateUserPremiumStatus(model: self.subsModel[SubscriptionViewController.selectedIdentifier]) { endWithSuccess in
//                        defaults.setValue(endWithSuccess, forKey: "userIsPremium")
//                        defaults.setValue(false, forKey: "is_cards_been_seen")
//                        Definations.isUserPremium = true
//                        if endWithSuccess {
//                            DispatchQueue.main.async { [weak self] in
//                                self?.view.addSubview((UIApplication.shared.delegate as? AppDelegate)!.confettiView)
//                                (UIApplication.shared.delegate as? AppDelegate)?.confettiView.showConfettis(for: 5)
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                self.removeSpinner()
//                                self.backGestureObserver()
//                            }
//                        } else {
//                            self.makeAlertDialog(title: "😔", message: "An error occured. Please try again later".localized(), buttonTitle: "OK".localized())
//                            self.removeSpinner()
//                        }
//                    }
                }
            }
        }
    }
    
    func restorePurchases(){
        Purchases.shared.restoreTransactions { info, error in
            guard let info = info, error == nil else { return }
            
            if info.entitlements.all["Subscriptions"]?.isActive == true {
                DispatchQueue.main.async {
                    // self?.label.isHidden = false
                    //self?.subscribeButton.isHidden = true
                    //self?.restoreButton.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    // self?.subscribeButton.isHidden = false
                    //self?.restoreButton.isHidden = false
                }
            }

        }
    }
    
    //MARK: GETSubscription
    func getSubscriptionDetails(completion: @escaping(Bool) -> ()) {
        DispatchQueue.main.async {
            Purchases.shared.offerings { (offerings, error) in
                print("contents = ", offerings)
                print("error = ", error)
                if let offerings = offerings {
                    let offer = offerings.current
                    let packages = offer?.availablePackages
                    
                    guard packages != nil else {
                        return
                    }
                  
                    // Loop through packages
                    for i in 0...packages!.count - 1 {
                        // Get a reference to the package
                        let package = packages![i]
                        
                        // Get a reference to the product
                        let product = package.product
                        
                        // Product title
                        //let title = product.localizedTitle
                        
                        // Product Price
                        var price = product.priceLocale.identifier
                        // Product duration
                        
                        
                        func unitName(unitRawValue:UInt) -> String {
                            switch unitRawValue
                            {
                                case 0:
                                    return "days"
                                case 1:
                                    return "week"
                                case 2:
                                    return "month"
                                case 3:
                                    return "year"
                                default:
                                    return ""
                            }
                        }
                        
                        var units : String! = ""
                        
                        if #available(iOS 11.2, *) {//period burada nil geliyor.
                          if let period = product.introductoryPrice?.subscriptionPeriod {
                              units = "\(period.numberOfUnits) \(unitName(unitRawValue: period.unit.rawValue)) " + "Free"
                            if period.numberOfUnits == 0 {

                            } else { }
                          } else { }
                        } else { }
                        
                        var isDeal = true
                        
                        if i == 0 {
                            isDeal = true
                        }
                        
                        
                        //: - purchase price cropper -
//                        if product.localizedTitle.contains("Yearly".localized()) {
//                             let priceF = price?.replacingOccurrences(of: product.priceLocale.currencySymbol ?? "", with: "").split(separator: ",")[0]
//                             if let priceMain = Int(priceF ?? "") {
//                                 let priceY = Int(priceMain) / 52
//                                 price = product.priceLocale.currencySymbol! + String(priceY) + " / " + "Week".localized()
//                             }
//                         }
//
//                         if product.localizedTitle.contains("Monthly".localized()) {
//                             let priceF = price?.replacingOccurrences(of: product.priceLocale.currencySymbol ?? "", with: "").split(separator: ",")[0]
//                             if let priceMain = Int(priceF ?? "") {
//                                 let priceM = Int(priceMain) / 4
//                                 price = product.priceLocale.currencySymbol! + String(priceM) + " / " + "Week".localized()
//                             }
//                         }
                        
                        let model = SubscriptionModel(
                            id: i,
                            mainTitle: product.localizedTitle,
                            subtitle: product.localizedDescription,
                            price: price ?? "nil",
                            isDeal: isDeal,
                            package: package,
                            dealTitle: units == nil ? "Save %80" : units
                        )
                        
                        self.subsModel.append(model)
                        print("subscription model item = ", model)
                    }
                }
            }
            completion(true)
        }
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
