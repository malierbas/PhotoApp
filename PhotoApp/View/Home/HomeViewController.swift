//
//  ViewController.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit
import IQKeyboardManagerSwift
import BottomPopup

class HomeViewController: BaseVC, BottomPopupDelegate {
    //MARK: - Properties
    //Views
    @IBOutlet weak var topImageCollectionView: UICollectionView!
    @IBOutlet weak var trendingCategoriesCollectionview: UICollectionView!
    @IBOutlet weak var allUserPhotosCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var allUserPhotosHeightAnchor: NSLayoutConstraint!
    
    //Variables
    let topImagesItems: [TopImageModel] = [
        TopImageModel(id: 1, productName: "Kogi Cosby 1", productOwner: "John Cirro 1", isFavourite: true),
        TopImageModel(id: 2, productName: "Kogi Cosby 2", productOwner: "John Cirro 2", isFavourite: false),
        TopImageModel(id: 3, productName: "Kogi Cosby 3", productOwner: "John Cirro 3", isFavourite: false),
        TopImageModel(id: 4, productName: "Kogi Cosby 4", productOwner: "John Cirro 4", isFavourite: false),
        TopImageModel(id: 5, productName: "Kogi Cosby 5", productOwner: "John Cirro 5", isFavourite: true),
        TopImageModel(id: 6, productName: "Kogi Cosby 6", productOwner: "John Cirro 6", isFavourite: false),
    ]
    
    let trendingImagesItems: [TrendingCategoriesModel] = [
        TrendingCategoriesModel(id: 1, icon: "sunset", backgrodundColors: ["#FF876B","#FFBCA6"], categoryName: "Sunset", filterCount: 123314),
        TrendingCategoriesModel(id: 2, icon: "mountain", backgrodundColors: ["#A06CFC","#FF92CB"], categoryName: "Mountain", filterCount: 44553),
        TrendingCategoriesModel(id: 3, icon: "makeUp", backgrodundColors: ["#669FFF","#ACFAFF"], categoryName: "Beauty", filterCount: 224)
    ]
    
    let images = [
        "begum1-2",
        "template8-2",
        "begum2-1",
        "begum2-2",
        "begum2",
        "begum3-1",
        "begum3",
        "begum4",
        "begum5-1",
        "begum5-2"
    ]
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
    }
    
    override func initListeners() {
        DispatchQueue.main.async {
            super.initListeners()
            self.trendingCategoriesCollectionview.delegate = self
            self.trendingCategoriesCollectionview.dataSource = self
            
            self.topImageCollectionView.delegate = self
            self.topImageCollectionView.dataSource = self
            
            self.allUserPhotosCollectionView.delegate = self
            self.allUserPhotosCollectionView.dataSource = self
            
            self.trendingCategoriesCollectionview.reloadData()
            self.allUserPhotosCollectionView.reloadData()
            self.topImageCollectionView.reloadData()
            
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            GlobalConstants.isCameraShown = false
            
            self.scrollView.sizeMatching = .Dynamic(
                width: {
                    self.view.frame.width
                },
                height: {
                    self.calculateScrollSize()
                }
            )
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GlobalConstants.isCameraShown = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GlobalConstants.isCameraShown = false
    }
    
    //MARK: - Public Functions
    //Calculate scroll size
    func calculateScrollSize() -> CGFloat {
        var height = CGFloat(100)
        
        height = height + self.topImageCollectionView.frame.height + self.trendingCategoriesCollectionview.frame.height + self.allUserPhotosCollectionView.contentSize.height + 300
        
        return height
    }
    
    func showPopup() {
        DispatchQueue.main.async {
            guard let popupVC = UIStoryboard(name: "MainPopup", bundle: nil).instantiateViewController(withIdentifier: "M72-OA-TgW") as? BasePopupVC else { return }
            popupVC.height = popupVC.view.frame.height * 1.3 / 3
            popupVC.topCornerRadius = 35
            popupVC.presentDuration = 0.5
            popupVC.dismissDuration = 0.5
            popupVC.popupDelegate = self
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    @objc func getMaskView(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let image = UIImage(named: "editImage")!.mergeWith(topImage: UIImage(named: "merge")!)
           
            let detailView = EditPhotoViewController(image: image)
            detailView.originalImage = image
            detailView.modalPresentationStyle = .fullScreen
            self.present(detailView, animated: true, completion: nil)
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView
        {
            case self.topImageCollectionView:
            
                return topImagesItems.count
            case self.allUserPhotosCollectionView:

                return self.images.count
            case self.trendingCategoriesCollectionview:
            
                return trendingImagesItems.count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView
        {
            case self.topImageCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopImageCVC", for: indexPath) as! TopImageCVC
                cell.data = self.topImagesItems[indexPath.row]
                return cell
            
            case self.trendingCategoriesCollectionview:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCategoriesCVC", for: indexPath) as! TrendingCategoriesCVC
                cell.data = self.trendingImagesItems[indexPath.row]
                return cell
            
            case self.allUserPhotosCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestSectionCVC", for: indexPath) as! InterestSectionCVC
                cell.image = UIImage(named: self.images[indexPath.row])
                return cell
            
            default:
            
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView
        {
            case self.topImageCollectionView:
            
                showPopup()
                NotificationCenter.default.addObserver(self, selector: #selector(self.getMaskView(notification:)), name: .init(rawValue: "canvas selected"), object: nil)
            
            case self.trendingCategoriesCollectionview:
            
//                showPopup()
//                NotificationCenter.default.addObserver(self, selector: #selector(self.getMaskView(notification:)), name: .init(rawValue: "canvas selected"), object: nil)
            
                DispatchQueue.main.async {
                    let detailView = CategoryDetailVC()
                    detailView.model = self.trendingImagesItems[indexPath.row]
                    detailView.modalPresentationStyle = .fullScreen
                    self.present(detailView, animated: true, completion: nil)
                }
            case self.allUserPhotosCollectionView:
            
                showPopup()
                NotificationCenter.default.addObserver(self, selector: #selector(self.getMaskView(notification:)), name: .init(rawValue: "canvas selected"), object: nil)
             
            default:
                break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView
        {
            case self.allUserPhotosCollectionView:
                if UIDevice.modelName == "iPhone 8" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else if UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 6" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else {
                    
                    return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
                }
            
            case self.topImageCollectionView:
            
                if UIDevice.modelName == "iPhone 8" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else if UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 6" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                }
                
            case self.trendingCategoriesCollectionview:
            
                if UIDevice.modelName == "iPhone 8" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else if UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 6" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                }
            
            default:
                return UIEdgeInsets()
        }
    }
}

/*
 
 //MARK: - Properties
 //Views
 private var topView: UIView = {
     let view = UIView()
     view.backgroundColor = .darkGray.withAlphaComponent(0.5)
     return view
 }()
 
 private var topLabel: UILabel = {
     let label = UILabel()
     label.text = "Photo Edit Controller"
     label.textColor = .white
     return label
 }()
 
 private var topSaveButton: UIButton = {
     let button = UIButton()
     button.setTitle("Save", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.tag = 10
     button.addTarget(self, action: #selector(saveButtonAction(_:)), for: .touchUpInside)
     return button
 }()
 
 private var currentImageView: UIImageView = {
     let imageView = UIImageView()
     imageView.contentMode = .scaleToFill
     imageView.image = UIImage(named: "nature")
     return imageView
 }()
 
 private var filtersScrollView: UIScrollView = {
     let scrollView = UIScrollView()
     
     return scrollView
 }()
 
 private var newScreenButton: UIButton = {
     let button = UIButton()
     button.setTitle("Show new screen", for: .normal)
     button.setTitleColor(.white, for: .normal)
     button.tag = 10
     button.addTarget(self, action: #selector(showNewScreen(_:)), for: .touchUpInside)
     return button
 }()
 
 //Variables
 var ciFilterNames = [
     "CIPhotoEffectChrome",
     "CIPhotoEffectFade",
     "CIPhotoEffectInstant",
     "CIPhotoEffectNoir",
     "CIPhotoEffectProcess",
     "CIPhotoEffectTonal",
     "CIPhotoEffectTransfer",
     "CISepiaTone"
 ]
 
 
 //MARK: - LifeCycle
 override func setupView() {
     super.setupView()
     //AddViews
     self.view.addSubview(topView)
     
     self.topView.addSubview(topLabel)
     
     self.topView.addSubview(topSaveButton)
     
     self.view.addSubview(currentImageView)
     
     self.view.addSubview(filtersScrollView)
     
     self.view.addSubview(newScreenButton)
     
     //Change Positions
     
     //topView
     self.topView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
     self.topView.heightAnchor.constraint(equalToConstant: 50).isActive = true
     self.topView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
     self.topView.translatesAutoresizingMaskIntoConstraints = false
     //topView.topLabel
     self.topLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0).isActive = true
     self.topLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor, constant: 0).isActive = true
     self.topLabel.translatesAutoresizingMaskIntoConstraints = false
     //topView.topSaveButton
     self.topSaveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
     self.topSaveButton.heightAnchor.constraint(equalToConstant: topView.frame.height).isActive = true
     self.topSaveButton.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 0).isActive = true
     self.topSaveButton.centerYAnchor.constraint(equalTo: topView.centerYAnchor, constant: 0).isActive = true
     self.topSaveButton.translatesAutoresizingMaskIntoConstraints = false
     //currentImageView
     self.currentImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
     self.currentImageView.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2.3).isActive = true
     self.currentImageView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
     self.currentImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
     self.currentImageView.translatesAutoresizingMaskIntoConstraints = false
     //filterScrollView
     self.filtersScrollView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
     self.filtersScrollView.heightAnchor.constraint(equalToConstant: 100).isActive = true
     self.filtersScrollView.topAnchor.constraint(equalTo: currentImageView.bottomAnchor, constant: 10).isActive = true
     self.filtersScrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
     self.filtersScrollView.translatesAutoresizingMaskIntoConstraints = false
     self.filtersScrollView.showsHorizontalScrollIndicator = false
     self.filtersScrollView.showsVerticalScrollIndicator = false
     //newscren buutton
     self.newScreenButton.widthAnchor.constraint(equalToConstant: 352).isActive = true
     self.newScreenButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
     self.newScreenButton.topAnchor.constraint(equalTo: self.filtersScrollView.bottomAnchor, constant: 70).isActive = true
     self.newScreenButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
     self.newScreenButton.translatesAutoresizingMaskIntoConstraints = false
     
     self.newScreenButton.backgroundColor = .black
     self.newScreenButton.layer.cornerRadius = 14
     
     //setup filter buttons
     setupFilterButtons()
     
     //setup save button
     self.topSaveButton.layer.backgroundColor = UIColor.white.cgColor
     self.topSaveButton.layer.cornerRadius = 12
     
 }
 
 override func initListeners() {
     super.initListeners()
     
 }
 
 //MARK: - Public Functions
 func setupFilterButtons() {
     var xCoord: CGFloat = 5
     var yCoord: CGFloat = 5
     let buttonWidth: CGFloat = 70
     let buttonHeight: CGFloat = 70
     let gapBetweenButtons: CGFloat = 5
     
     var itemCount = 0
     
     for i in 0..<self.ciFilterNames.count {
         itemCount = i
         
         //buttonProperties
         let filterButton = UIButton(type: .custom)
         filterButton.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
         filterButton.tag = itemCount
         filterButton.addTarget(self, action: #selector(self.filterButtonTapped(_:)), for: .touchUpInside)
         filterButton.layer.cornerRadius = 12
         filterButton.clipsToBounds = true
         
         let mainImage = UIImage(named: "nature")
         let ciContext = CIContext(options: nil)
         let coreImage = CIImage(image: mainImage!)
         let filter = CIFilter(name: self.ciFilterNames[i])
         filter!.setDefaults()
         filter?.setValue(coreImage, forKey: kCIInputImageKey)
         let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
         let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
         let imageForButton = UIImage(cgImage: filteredImageRef!)
         
         filterButton.setImage(imageForButton, for: .normal)
         xCoord += buttonWidth + gapBetweenButtons
         filtersScrollView.addSubview(filterButton)
     }
     
     filtersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount + 2), height: yCoord)
 }
 
 //MARK: - Actions
 @objc func filterButtonTapped(_ sender: UIButton) {
     let mainImage = UIImage(named: "nature")
     let ciContext = CIContext(options: nil)
     let coreImage = CIImage(image: mainImage!)
     let filter = CIFilter(name: self.ciFilterNames[sender.tag])
     filter!.setDefaults()
     filter?.setValue(coreImage, forKey: kCIInputImageKey)
     let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
     let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
     let imageForButton = UIImage(cgImage: filteredImageRef!)
     
     currentImageView.image = imageForButton
 }
 
 @objc func saveButtonAction(_ sender: UIButton) {
      UIImageWriteToSavedPhotosAlbum(self.currentImageView.image!, nil, nil, nil)
      
      let alert = UIAlertController(title: "Saved", message: "Filtered Image Saved!!", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
 }
 
 @objc func showNewScreen(_ sender: UIButton) {
     let vc = ChangeBackgroundViewController()
     vc.modalPresentationStyle = .fullScreen
     
     self.present(vc, animated: true, completion: nil)
 }
 
 //MARK: - Save with shake
 override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
     UIImageWriteToSavedPhotosAlbum(self.currentImageView.image!, nil, nil, nil)
     
     let alert = UIAlertController(title: "Saved", message: "Filtered Image Saved!!", preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
     self.present(alert, animated: true, completion: nil)
 }
 
 */




//
//import UIKit
//
//class HomeViewController: UIViewController {
//
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.sectionHeaderHeight = 0
//        tableView.sectionFooterHeight = 0
//        tableView.backgroundColor = UIColor.clear
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.separatorStyle = .none
//        tableView.showsVerticalScrollIndicator = false
//        tableView.estimatedRowHeight = UITableView.automaticDimension
//        tableView.contentInsetAdjustmentBehavior = .never
//        tableView.contentInset = .init(topPadding: 16, bottomPadding: 40)
//        return tableView
//    }()
//
//    var templateSections: [TemplateSection] = [
//        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
//        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
//        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
//    ]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        prepareUI()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//    private func prepareUI() {
//        view.backgroundColor = UIColor(hexString: "#1C1F21")
//        navigationController?.view.backgroundColor = UIColor(hexString: "#1C1F21")
//        tableView.register(SectionTableViewCell.self)
//        view.addSubview(tableView)
//        setupNavigationBar()
//        setupLayout()
//        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: nil) { (_) in
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                var title = "Unlock Premium"
//
//                if globalAppConstants.shouldUpdate == false {
//                    title = "Try for free"
//                }
//
//                if globalAppConstants.shouldUpdate == false && globalAppConstants.inAppPurchaseData?.isWeeklyGiftActive == true {
//                    title = "Claim your gift 🎁"
//                }
//                self.navigationItem.rightBarButtonItem = LocalStorageManager.shared.isPremiumUser ? nil : UIBarButtonItem(title: title, style: .done, target: self, action: #selector(self.rightNavigationBarButtonItemTapped))
//            }
//        }
//    }
//
//    private func setupLayout() {
//        tableView.anchor(top: view.topAnchor,
//                         leading: view.leadingAnchor,
//                         trailing: view.trailingAnchor,
//                         bottom: view.bottomAnchor)
//    }
//
//    private func setupNavigationBar() {
//        navigationItem.title = "Templates"
//        navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem?.tintColor = .white
//        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#1C1F21")
//        navigationController!.navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
//            .foregroundColor: UIColor.white
//        ]
//        navigationController!.navigationBar.largeTitleTextAttributes = [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .medium),
//            .foregroundColor: UIColor.white
//        ]
//
//        if !LocalStorageManager.shared.isPremiumUser {
//            var title = "Unlock Premium"
//
//            if globalAppConstants.shouldUpdate == false {
//                title = "Try for free"
//            }
//
//            if globalAppConstants.shouldUpdate == false && globalAppConstants.inAppPurchaseData?.isWeeklyGiftActive == true {
//                title = "Claim your gift 🎁"
//            }
//            navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightNavigationBarButtonItemTapped))
//        }
//        navigationController?.navigationBar.tintColor = .white
//    }
//
//    @objc func rightNavigationBarButtonItemTapped() {
//        UIImpactFeedbackGenerator().impactOccurred()
//        if globalAppConstants.shouldUpdate == false && globalAppConstants.inAppPurchaseData?.isWeeklyGiftActive == true {
//            presentInFullScreen(SubscriptionGiftViewController(), animated: true)
//        } else {
//            presentInFullScreen(SubscriptionViewController(), animated: true, completion: nil)
//        }
//    }
//}
//
//extension HomeViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return templateSections.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SectionTableViewCell.reuseIdentifier, for: indexPath) as? SectionTableViewCell else { return UITableViewCell() }
//
//        let section = templateSections[indexPath.row]
//        cell.templates = section.templates
//        cell.delegate = self
//        cell.titleLabel.text = section.title
//        cell.seeAllButton.isHidden = !section.hasSeeAllButton
//        return cell
//    }
//}
//
//extension HomeViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        UIImpactFeedbackGenerator().impactOccurred()
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//}
//
//extension HomeViewController: SectionTableViewCellDelegate {
//    func didSelectSeeAllButton(onCell cell: SectionTableViewCell) {
////        guard let indexPathOfCell = tableView.indexPath(for: cell) else { return }
////        let section = templateSections[indexPathOfCell.row]
//        UIImpactFeedbackGenerator().impactOccurred()
//        let sectionSeeAllViewController = SectionSeeAllViewController()
//        sectionSeeAllViewController.title = "Templates"
//        sectionSeeAllViewController.sections = templateSections
//        self.navigationController?.pushViewController(sectionSeeAllViewController, animated: true)
//    }
//
//    func didSelectCell(atIndexPath indexPath: IndexPath, onCell cell: SectionTableViewCell) {
//        UIImpactFeedbackGenerator().impactOccurred()
//        guard let sectionIndexPath = tableView.indexPath(for: cell) else { return }
//        guard let templates = self.templateSections[sectionIndexPath.row].templates else { return }
//        let template = templates[indexPath.item]
//        let editorViewController = EditorViewController()
//        editorViewController.template = template
//        editorViewController.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(editorViewController, animated: true)
//    }
//}
