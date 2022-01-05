//
//  ViewController.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit
import IQKeyboardManagerSwift
import BottomPopup
import SVProgressHUD

class HomeViewController: UIViewController, BottomPopupDelegate {
    //MARK: - Properties
    //Views
    private lazy var topCollectionView: UICollectionView = {
        let flowLayout = ZoomAndSnapFlowLayout()
        flowLayout.itemSize = CGSize(width: 223, height: 338)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)  
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    @IBOutlet weak var nightLabel: UILabel!
    @IBOutlet weak var topImageCollectionView: UICollectionView!
    @IBOutlet weak var trendingCategoriesCollectionview: UICollectionView!
    @IBOutlet weak var allUserPhotosCollectionView: UICollectionView!
    @IBOutlet weak var modernistCollectionView: UICollectionView!
    @IBOutlet weak var collectionCategoryCV: UICollectionView!
    @IBOutlet weak var templatesCollectionView: UICollectionView!
    @IBOutlet weak var highlightsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var tryForFreeButton: UIButton!
    
    //: collection title
    @IBOutlet weak var templatesTextLabel: UILabel!
    @IBOutlet weak var lovelyBlushTextLabel: UILabel!
    @IBOutlet weak var modernistTextLabel: UILabel!
    @IBOutlet weak var collectionTextLabel: UILabel!
    @IBOutlet weak var highlightsTextLabel: UILabel!
    
    //: collectionSeeAll
    @IBOutlet weak var popularSeeMore: UIButton!
    @IBOutlet weak var lovelyBlushSeeMore: UIButton!
    @IBOutlet weak var modernistSeeMore: UIButton!
    @IBOutlet weak var collectionSeeMore: UIButton!
    @IBOutlet weak var highlightsSeeMore: UIButton!
    
    //: stack views
    @IBOutlet weak var topImageStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var lovelyBlushStack: UIStackView!
    @IBOutlet weak var modernistStack: UIStackView!
    @IBOutlet weak var collectionStack: UIStackView!
    @IBOutlet weak var highlightsStack: UIStackView!
    
    //: limited time offer view
    @IBOutlet weak var limitedTimerStackView: UIStackView!
    @IBOutlet weak var mainOfferView: UIView!
    @IBOutlet weak var timerImageView: UIImageView!
    @IBOutlet weak var timerBackgroundview: UIImageView!
    @IBOutlet weak var timerOneView: UIView!
    @IBOutlet weak var timerOneLAbel: UILabel!
    @IBOutlet weak var timerTwoView: UIView!
    @IBOutlet weak var timerTwoLAbel: UILabel!
    @IBOutlet weak var timerThreeView: UIView!
    @IBOutlet weak var timerThreeLabel: UILabel!
    @IBOutlet weak var limitedOfferViewDescLabel: UILabel!
    //: limited offer view cons
    @IBOutlet weak var limitetOfferStackViewCons: NSLayoutConstraint!
    
    //Variables
    var cellScale: CGFloat = 0.6
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    var isPost: Bool? = false
    var destinationModel: CategoryContentModel!
    
    var templateNames: [String]! = [
        "All",
        "Story",
        "Post & Banner",
        "Quote"
    ]
    
    var selectedItem: String! {
        didSet
        {
            self.setupTrendCollectionView()
        }
    }
    
    var desctinationURL = "showCommonContent"
    var isCollectionAppearEnded = false
    
    var seconds = LocalStorageManager.shared.offerTimerTime ?? 90000
    var timer = Timer()
    var isTimerRunning = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //: code collection view
        self.topCollectionView.register(TopImageCollectionViewCell.self, forCellWithReuseIdentifier: "TopImageCollectionViewCell")
        self.topImageStackView.addArrangedSubview(self.topCollectionView)
        self.topCollectionView.fillSuperview()
        self.topCollectionView.reloadData()
        //: add transform
        self.tryForFreeButton.addTransform()
        self.nightLabel.addTransform()
        //: flow layout
        let flowLayout = ZoomAndSnapFlowLayout()
        self.topImageCollectionView.contentInsetAdjustmentBehavior = .always
        self.topImageCollectionView.collectionViewLayout = flowLayout
        //: navigation bar
        self.setupNavigationView(isHidden: false)
        //: try for free
        self.tryForFreeButton.layer.cornerRadius = 14
        //: collection view
        self.trendingCategoriesCollectionview.delegate = self
        self.trendingCategoriesCollectionview.dataSource = self
        
        self.topImageCollectionView.delegate = self
        self.topImageCollectionView.dataSource = self
        self.topImageCollectionView.alwaysBounceVertical = false
        self.topImageCollectionView.alwaysBounceHorizontal = false
        
        self.allUserPhotosCollectionView.delegate = self
        self.allUserPhotosCollectionView.dataSource = self
        
        self.modernistCollectionView.delegate = self
        self.modernistCollectionView.dataSource = self
        
        self.collectionCategoryCV.delegate = self
        self.collectionCategoryCV.dataSource = self
        
        self.templatesCollectionView.dataSource = self
        self.templatesCollectionView.delegate = self
        
        self.highlightsCollectionView.delegate = self
        self.highlightsCollectionView.dataSource = self
        
        self.topImageCollectionView.reloadData()
        self.trendingCategoriesCollectionview.reloadData()
        self.allUserPhotosCollectionView.reloadData()
        self.modernistCollectionView.reloadData()
        self.collectionCategoryCV.reloadData()
        self.templatesCollectionView.reloadData()
        self.highlightsCollectionView.reloadData()
        //: scroll view
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
        GlobalConstants.isCameraShown = false
        self.setupScrollView()
        //: offer view
        self.timerBackgroundview.layer.cornerRadius = 12
        
        self.timerOneView.layer.cornerRadius = 4
        self.timerTwoView.layer.cornerRadius = 4
        self.timerThreeView.layer.cornerRadius = 4
        
        //: run timer
        self.runTimer()
        self.updateTimer()
        
        //: gesture
        let timerDetailGesture = UITapGestureRecognizer(target: self, action: #selector(self.showTimerDetailVC))
        self.limitedTimerStackView.addGestureRecognizer(timerDetailGesture)
        
        //: - premium notification -
        NotificationCenter.default.addObserver(forName: .init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: .main) { notification in
            if LocalStorageManager.shared.isOfferViewShown
            {
                //: hide offer view
                DispatchQueue.main.async {
                    self.mainOfferView.isHidden = true
                    self.limitetOfferStackViewCons.constant = 0
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("is premium user = ", LocalStorageManager.shared.isPremiumUser)
        if LocalStorageManager.shared.isPremiumUser
        {
            //: hide offer view
            DispatchQueue.main.async {
                self.tryForFreeButton.fadeOut()
                self.mainOfferView.isHidden = true
                self.limitetOfferStackViewCons.constant = 0
            }
        }
        
        GlobalConstants.isCameraShown = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var height: CGFloat = 0
        
        switch UIDevice.modelName
        {
            case "iPhone 8", "Simulator iPhone 8":
                height = self.view.frame.height - 48
            case "iPhone 6", "Simulator iPhone 6":
                height = self.view.frame.height - 48
            case "iPhone 5", "Simulator iPhone 5":
                height = self.view.frame.height - 48
            case "iPhone 6s", "Simulator iPhone 6s":
                height = self.view.frame.height - 48
            case "iPhone 8 Plus", "Simulator iPhone 8 Plus":
                height = self.view.frame.height - 49
            default:
                height = self.view.frame.height - 65
        }
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: height, width: self.tabBarController?.tabBar.frame.size.width ?? 0, height: self.tabBarController?.tabBar.frame.size.height ?? 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.navigationBar.isHidden = true
        switch segue.identifier
        {
            case desctinationURL:
                if let viewC = segue.destination as? CommonContentVC
                {
                    viewC.categoryContentModel = self.destinationModel
                    viewC.isPost = self.isPost
                }
                break
            
            case "showAllCollections":
                if let viewC = segue.destination as? AllHighlightsVC
                {
                    viewC.categoryContentModel = self.destinationModel
                }
                break
            
            case "showHiglightsVC":
                if let viewC = segue.destination as? HighlightsDetailViewC
                {
                    viewC.categoryContentModel = self.destinationModel
                }
                break
            
            default:
                break
        }
    }
    
    //MARK: - Public Functions
    
    //: setup scroll view
    func setupScrollView() {
        self.scrollView.sizeMatching = .Dynamic(
            width: {
                self.view.frame.width
            },
            height: {
                self.calculateScrollSize()
            }
        )
    }
    
    //Calculate scroll size
    func calculateScrollSize() -> CGFloat {
        var height = CGFloat(400)
        
        height = height + self.topCollectionView.frame.height + self.trendingCategoriesCollectionview.frame.height + self.allUserPhotosCollectionView.frame.height + self.modernistCollectionView.frame.height + self.collectionCategoryCV.frame.height + self.templatesCollectionView.frame.height + 450
        
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
    
    func setupNavigationView(isHidden: Bool, isTranslucent: Bool? = true) {
        //: right items
        self.navigationController?.navigationBar.isHidden = isHidden
        let tryForFreeBtn = UIBarButtonItem(customView: self.tryForFreeButton)
        self.navigationItem.rightBarButtonItem = tryForFreeBtn
        //: left item
        let viewNameLabel = UIBarButtonItem(customView: self.nightLabel)
        self.navigationItem.leftBarButtonItem = viewNameLabel
        //: navigation view
        self.navigationController?.navigationBar.isTranslucent = isTranslucent ?? false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ViewBlackBG")
        //: visible
        self.tryForFreeButton.fadeIn()
        self.nightLabel.fadeIn()
    }
    
    func setupTrendCollectionView() {
        switch self.selectedItem
        {
            case "All":
                print("selected 1 = ", selectedItem ?? "nil")
                self.animateStack(makeHidden: false, with: self.lovelyBlushStack, reloadScroll: true)
                self.animateStack(makeHidden: false, with: self.modernistStack, reloadScroll: true)
                self.animateStack(makeHidden: false, with: self.collectionStack, reloadScroll: true)
                self.animateStack(makeHidden: false, with: self.highlightsStack, reloadScroll: true)
            case "Story":
                print("selected 2 = ", selectedItem ?? "nil")
                self.animateStack(makeHidden: false, with: self.lovelyBlushStack, reloadScroll: true)
                self.animateStack(makeHidden: false, with: self.modernistStack, reloadScroll: true)
                self.animateStack(makeHidden: true, with: self.collectionStack, reloadScroll: true)
                self.animateStack(makeHidden: true, with: self.highlightsStack, reloadScroll: true)
            case "Post & Banner":
                print("selected 3 = ", selectedItem ?? "nil")
                self.animateStack(makeHidden: true, with: self.lovelyBlushStack, reloadScroll: true)
                self.animateStack(makeHidden: true, with: self.modernistStack, reloadScroll: true)
                self.animateStack(makeHidden: false, with: self.collectionStack, reloadScroll: true)
                self.animateStack(makeHidden: true, with: self.highlightsStack, reloadScroll: true)
            case "Quote":
                print("selected 4 = ", selectedItem ?? "nil")
                self.animateStack(makeHidden: false, with: self.lovelyBlushStack, reloadScroll: true)
                self.animateStack(makeHidden: true, with: self.modernistStack, reloadScroll: true)
                self.animateStack(makeHidden: true, with: self.collectionStack, reloadScroll: true)
                self.animateStack(makeHidden: true, with: self.highlightsStack, reloadScroll: true)
            default:
                break
        }
    }
    
    func animateStack(makeHidden: Bool, with animateView: UIStackView, reloadScroll: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.35, delay: 1, options: .curveEaseOut) {
                animateView.alpha = 1
            } completion: { didComplete in
                if didComplete
                {
                    animateView.isHidden = makeHidden
                }
            }
            
            if reloadScroll
            {
                self.setupScrollView()
            }
        }
    }
    
    func animateSelection(animateView: UIView, reloadScroll: Bool) {
        DispatchQueue.main.async {
            animateView.alpha = 0
            UIView.animate(withDuration: 0.35, delay: 0.35, options: .curveLinear) {
                animateView.alpha = 1
            } completion: { didComplete in
                animateView.isHidden = false
                
                if reloadScroll
                {
                    self.setupScrollView()
                }
            }
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    func timeString(time: TimeInterval) {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        self.timerOneLAbel.text = String(hours)
        self.timerTwoLAbel.text = String(minutes)
        self.timerThreeLabel.text = String(second)
        
        LocalStorageManager.shared.offerTimerTime = Int(time)
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
    
    @IBAction func showAllCategories(_ sender: Any) {
        DispatchQueue.main.async {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    @IBAction func showAllCategoriesSecond(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Lovely", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.isPost = false
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesThird(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Modernist", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.isPost = false
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesFourth(_ sender: Any) {
        DispatchQueue.main.async {
            self.isPost = true
            self.destinationModel = CategoryContentModel(contentName: "Collection", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
        }
    }
    
    
    @IBAction func showAllCategoriesFifth(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Highlights", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.isPost = false
            self.performSegue(withIdentifier: "showAllCollections", sender: nil)
        }
    }
    
    @IBAction func tryForFreeBtnAction(_ sender: Any) {
        
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PaywallViewController") as? PaywallViewController else { return }
        self.presentInFullScreen(vc, animated: true) {
            //: do something
        }
    }
    
    @objc func updateTimer() {
        seconds -= 1
        timeString(time: TimeInterval(seconds))
    }
    
    @objc func showTimerDetailVC() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PurchaseTimerViewController") as? PurchaseTimerViewController else { return }
        vc.seconds = LocalStorageManager.shared.offerTimerTime ?? 90000
        self.presentInFullScreen(vc, animated: true) {
            //: do something
        }
    }
}

//MARK: - CollectionView Delegate, DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView
        {
            case self.topCollectionView:
            
                return self.templateSections[0].templates?.count ?? 0
            case self.topImageCollectionView:
            
                return self.templateSections[0].templates?.count ?? 0
            case self.allUserPhotosCollectionView:

                return self.templateSections[0].templates?.count ?? 0
            case self.trendingCategoriesCollectionview:
            
                return 8
            case self.modernistCollectionView:
            
                return self.templateSections[0].templates?.count ?? 0
            case self.collectionCategoryCV:
            
                return self.templateSections[0].templates?.count ?? 0
            case self.templatesCollectionView:
            
                return self.templateNames.count
            case self.highlightsCollectionView:
            
                return self.templateSections[0].templates?.count ?? 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView
        {
            case self.topCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopImageCollectionViewCell", for: indexPath) as! TopImageCollectionViewCell
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.imageView.image = data.templateCoverImage
                return cell
            case self.topImageCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopImageCVC", for: indexPath) as! TopImageCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.data = data
            
                if !self.isCollectionAppearEnded
                {
                    if indexPath.row == 1
                    {
                        let item = IndexPath(row: 1, section: 0)
                        self.topImageCollectionView.scrollToItem(at: item, at: .centeredHorizontally, animated: false)
                        let secondItem = IndexPath(row: 0, section: 0)
                        self.topImageCollectionView.scrollToItem(at: secondItem, at: .centeredHorizontally, animated: true)
                        self.isCollectionAppearEnded = true
                    }
                }
               
                return cell
            case self.trendingCategoriesCollectionview:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCategoriesCVC", for: indexPath) as! TrendingCategoriesCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.data = data
                return cell
            case self.allUserPhotosCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestSectionCVC", for: indexPath) as! InterestSectionCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
                return cell
            case self.modernistCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestSectionBCVC", for: indexPath) as! InterestSectionCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
                return cell
            case self.collectionCategoryCV:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestSectionCCVC", for: indexPath) as! InterestSectionCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
                return cell
            case self.templatesCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplatesCVC", for: indexPath) as! TemplatesCVC
            
                let cellText = self.templateNames[indexPath.row]
                let contentWidth: CGFloat = cellText.size(withAttributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 14)!]).width + 62
                cell.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
            
                cell.data = self.templateNames[indexPath.row]
                if indexPath.row == 0
                {
                    cell.backgroundColor = UIColor(named: "ViewRedBG")
                    cell.templateName.textColor = .white
                }
                return cell
            
            case self.highlightsCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHighlightsCell", for: indexPath) as! HomeHighlightsCell
                guard let data = self.templateSections[0].templates?[indexPath.row]  else { return UICollectionViewCell() }
                cell.data = data
                return cell
            
            default:
            
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        switch collectionView
        {
            case self.topCollectionView:
            
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                GlobalConstants.canvasType = -1
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
            
            case self.trendingCategoriesCollectionview:
                DispatchQueue.main.async {
                    self.destinationModel = CategoryContentModel(contentName: "Popular", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
                }
            case self.allUserPhotosCollectionView:
             
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                GlobalConstants.canvasType = -1
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
            case self.modernistCollectionView:
            
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                GlobalConstants.canvasType = -1
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
            case self.collectionCategoryCV:
            
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                GlobalConstants.canvasType = -1
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
            
            case self.templatesCollectionView:
                DispatchQueue.main.async {
                    let cell = self.templatesCollectionView.cellForItem(at: indexPath) as! TemplatesCVC
                    for item in self.templatesCollectionView.visibleCells {
                        if let firstCell = item as? TemplatesCVC {
                            if cell == firstCell {
                                //selected
                                self.animateSelection(animateView: self.mainStackView, reloadScroll: true)
                                cell.templateName.textColor = .white
                                cell.backgroundColor = UIColor(named: "ViewRedBG")
                                self.selectedItem = cell.templateName.text
                            } else {
                                //unselected
                                firstCell.templateName.textColor = .black
                                firstCell.backgroundColor = .white
                            }
                        }
                    }
                }
            
            case self.highlightsCollectionView:
                DispatchQueue.main.async {
                    self.destinationModel = CategoryContentModel(contentName: "Content \(indexPath.row)", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: "showHiglightsVC", sender: nil)
                }
            default:
                break
        }
    }
}

//MARK: - Change Tabbar Label
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView
        {
            case self.scrollView:
                let frame: CGFloat = self.templatesTextLabel.frame.origin.y - 100
            
                if scrollView.contentOffset.y > frame
                {
                    self.nightLabel.text = "Templates"
                }
                else
                {
                    self.nightLabel.text = "Good Night"
                }
            default:
                break
        }
    }
}
