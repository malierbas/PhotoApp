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
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var lovelyBlushStack: UIStackView!
    @IBOutlet weak var modernistStack: UIStackView!
    @IBOutlet weak var collectionStack: UIStackView!
    @IBOutlet weak var highlightsStack: UIStackView!
    
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
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
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
    }
    
    override func initListeners() {
        super.initListeners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GlobalConstants.isCameraShown = false
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
            
            default:
                break
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - 65
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
        var height = CGFloat(300)
        
        height = height + self.topImageCollectionView.frame.height + self.trendingCategoriesCollectionview.frame.height + self.allUserPhotosCollectionView.frame.height + self.modernistCollectionView.frame.height + self.collectionCategoryCV.frame.height + self.templatesCollectionView.frame.height + 450
        
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
}

//MARK: - CollectionView Delegate, DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView
        {
            case self.topImageCollectionView:
            
                return self.templateSections[0].templates?.count ?? 0
            case self.allUserPhotosCollectionView:

                return 8
            case self.trendingCategoriesCollectionview:
            
                return self.templateSections[0].templates?.count ?? 0
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
            case self.topImageCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopImageCVC", for: indexPath) as! TopImageCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.data = data
                cell.addTransform()
            
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
                cell.addTransform()
                return cell
            case self.allUserPhotosCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestSectionCVC", for: indexPath) as! InterestSectionCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
                cell.addTransform()
                return cell
            case self.modernistCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestSectionBCVC", for: indexPath) as! InterestSectionCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
                cell.addTransform()
                return cell
            case self.collectionCategoryCV:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestSectionCCVC", for: indexPath) as! InterestSectionCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
                cell.addTransform()
                return cell
            case self.templatesCollectionView:
            
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplatesCVC", for: indexPath) as! TemplatesCVC
            
                let cellText = self.templateNames[indexPath.row]
                let contentWidth: CGFloat = cellText.size(withAttributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 14)!]).width + 62
                cell.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
            
                cell.data = self.templateNames[indexPath.row]
                cell.addTransform()
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
                cell.addTransform()
                return cell
            
            default:
            
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView
        {
            case self.topImageCollectionView:
            
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
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
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
            case self.modernistCollectionView:
            
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
            case self.collectionCategoryCV:
            
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
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
                
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
            
            default:
                break
        }
    }
}

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
