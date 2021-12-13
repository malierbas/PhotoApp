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
    
    //: collection height constraints
    @IBOutlet weak var lovelyBlushHeight: NSLayoutConstraint!//: 257
    @IBOutlet weak var modernistHeight: NSLayoutConstraint!//: 257
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!//: 117
    @IBOutlet weak var highlightsHeight: NSLayoutConstraint!//: 95
    
    //Variables
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
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
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        //: navigation bar
        self.setupNavigationView(isHidden: false)
        //: try for free 
        self.tryForFreeButton.layer.cornerRadius = 14
        //: collection view
        self.trendingCategoriesCollectionview.delegate = self
        self.trendingCategoriesCollectionview.dataSource = self
        
        self.topImageCollectionView.delegate = self
        self.topImageCollectionView.dataSource = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GlobalConstants.isCameraShown = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
            case desctinationURL:
                if let viewC = segue.destination as? CommonContentVC
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
        var height = CGFloat(200)
        
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
    }
    
    func setupTrendCollectionView() {
        switch self.selectedItem
        {
            case "All":
                print("selected 1 = ", selectedItem ?? "nil")
                DispatchQueue.main.async {
                    self.lovelyBlushHeight.constant = 257
                    self.modernistHeight.constant = 257
                    self.collectionHeight.constant = 117
                    self.highlightsHeight.constant = 95
                    
                    self.collectionSeeMore.isHidden = false
                    self.collectionTextLabel.isHidden = false
                    
                    self.highlightsTextLabel.isHidden = false
                    self.highlightsSeeMore.isHidden = false
                    
                    self.modernistTextLabel.isHidden = true
                    self.modernistSeeMore.isHidden = false
                    
                    self.lovelyBlushSeeMore.isHidden = false
                    self.lovelyBlushTextLabel.isHidden = false
                    
                    self.setupScrollView()
                }
            case "Story":
                print("selected 2 = ", selectedItem ?? "nil")
                DispatchQueue.main.async {
                    self.collectionHeight.constant = 95
                    self.highlightsHeight.constant = 0
                    self.modernistHeight.constant = 0
                    self.lovelyBlushHeight.constant = 0
                    
                    self.collectionSeeMore.isHidden = false
                    self.collectionTextLabel.isHidden = false
                    
                    self.highlightsTextLabel.isHidden = true
                    self.highlightsSeeMore.isHidden = true
                    
                    self.modernistTextLabel.isHidden = true
                    self.modernistSeeMore.isHidden = true
                    
                    self.lovelyBlushSeeMore.isHidden = true
                    self.lovelyBlushTextLabel.isHidden = true
                    
                    self.setupScrollView()
                }
            case "Post & Banner":
                print("selected 3 = ", selectedItem ?? "nil")
                DispatchQueue.main.async {
                    self.collectionHeight.constant = 0
                    self.highlightsHeight.constant = 0
                    self.modernistHeight.constant = 257
                    self.lovelyBlushHeight.constant = 257
                    
                    self.collectionSeeMore.isHidden = true
                    self.collectionTextLabel.isHidden = true
                    
                    self.highlightsTextLabel.isHidden = true
                    self.highlightsSeeMore.isHidden = true
                    
                    self.modernistTextLabel.isHidden = false
                    self.modernistSeeMore.isHidden = false
                    
                    self.lovelyBlushSeeMore.isHidden = false
                    self.lovelyBlushTextLabel.isHidden = false
                    
                    self.setupScrollView()
                }
            case "Quote":
                print("selected 4 = ", selectedItem ?? "nil")
                DispatchQueue.main.async {
                    self.collectionHeight.constant = 0
                    self.highlightsHeight.constant = 0
                    self.modernistHeight.constant = 0
                    self.lovelyBlushHeight.constant = 0
                    
                    self.collectionSeeMore.isHidden = true
                    self.collectionTextLabel.isHidden = true
                    
                    self.highlightsTextLabel.isHidden = true
                    self.highlightsSeeMore.isHidden = true
                    
                    self.modernistTextLabel.isHidden = true
                    self.modernistSeeMore.isHidden = true
                    
                    self.lovelyBlushSeeMore.isHidden = true
                    self.lovelyBlushTextLabel.isHidden = true
                    
                    self.setupScrollView()
                }
            default:
                break
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
            self.destinationModel = CategoryContentModel(contentName: "Popular", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesSecond(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Lovely", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesThird(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Modernist", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesFourth(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Collection", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
        }
    }
    
    
    @IBAction func showAllCategoriesFifth(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Highlights", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
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

                return self.templateSections[0].templates?.count ?? 0
            case self.trendingCategoriesCollectionview:
            
                return 4
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
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.data = data
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
             
                DispatchQueue.main.async {
                    self.destinationModel = CategoryContentModel(contentName: "Lovely", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
                }
            case self.modernistCollectionView:
            
                DispatchQueue.main.async {
                    self.destinationModel = CategoryContentModel(contentName: "Modernist", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
                }
            case self.collectionCategoryCV:
            
                DispatchQueue.main.async {
                    self.destinationModel = CategoryContentModel(contentName: "Collection", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
                }
            case self.templatesCollectionView:
                DispatchQueue.main.async {
                    let cell = self.templatesCollectionView.cellForItem(at: indexPath) as! TemplatesCVC
                    for item in self.templatesCollectionView.visibleCells {
                        if let firstCell = item as? TemplatesCVC {
                            if cell == firstCell {
                                //selected
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
                    self.destinationModel = CategoryContentModel(contentName: "Highlights", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: self.desctinationURL, sender: nil)
                }
            default:
                break
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
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
