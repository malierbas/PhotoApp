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
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var tryForFreeButton: UIButton!
    @IBOutlet weak var templatesTextLabel: UILabel!
    
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
        
        self.topImageCollectionView.reloadData()
        self.trendingCategoriesCollectionview.reloadData()
        self.allUserPhotosCollectionView.reloadData()
        self.modernistCollectionView.reloadData()
        self.collectionCategoryCV.reloadData()
        self.templatesCollectionView.reloadData()
        //: scroll view
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.delegate = self
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
            case "showAllCollections":
                if let viewC = segue.destination as? SeeAllCategoriesVC
                {
                    viewC.categoryContentModel = self.destinationModel
                }
                break
            default:
                break
        }
    }
    
    //MARK: - Public Functions
    //Calculate scroll size
    func calculateScrollSize() -> CGFloat {
        var height = CGFloat(100)
        
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
            case "Story":
                print("selected 2 = ", selectedItem ?? "nil")
            case "Post & Banner":
                print("selected 3 = ", selectedItem ?? "nil")
            case "Quote":
                print("selected 4 = ", selectedItem ?? "nil")
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
            self.performSegue(withIdentifier: "showAllCollections", sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesSecond(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Lovely", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: "showAllCollections", sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesThird(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Modernist", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: "showAllCollections", sender: nil)
        }
    }
    
    @IBAction func showAllCategoriesFourth(_ sender: Any) {
        DispatchQueue.main.async {
            self.destinationModel = CategoryContentModel(contentName: "Collection", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
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

                return self.templateSections[0].templates?.count ?? 0
            case self.trendingCategoriesCollectionview:
            
                return 4
            case self.modernistCollectionView:
            
                return self.templateSections[0].templates?.count ?? 0
            case self.collectionCategoryCV:
            
                return self.templateSections[0].templates?.count ?? 0
            case self.templatesCollectionView:
            
                return self.templateNames.count
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

                guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
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
