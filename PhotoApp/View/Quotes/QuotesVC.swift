//
//  QuotesVC.swift
//  PhotoApp
//
//  Created by Ali on 11.12.2021.
//

import UIKit

class QuotesVC: BaseVC {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var tryForFreeButtonOutlet: UIButton!
    @IBOutlet weak var quotesFirstCollectionView: UICollectionView!
    
    //: Variables
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    
    var categoryContentModel: CategoryContentModel!
    var isLoaded: Bool! = false
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()

        DispatchQueue.main.async {
            //: transform
            self.quotesFirstCollectionView.addTransform()
            //: navigation bar
            self.setupNavigationView(isHidden: false)
            //: collection views
            self.quotesFirstCollectionView.delegate = self
            self.quotesFirstCollectionView.dataSource = self
            self.quotesFirstCollectionView.reloadData()
            self.quotesFirstCollectionView.setContentOffset(CGPoint(x: 0, y: 120), animated: true)
            self.quotesFirstCollectionView.fadeOut()
            //: try for free btn
            self.tryForFreeButtonOutlet.layer.cornerRadius = 14
            //: scrollView
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case "showDetailScreen":
            if let vc = segue.destination as? CommonContentVC
            {
                vc.categoryContentModel = self.categoryContentModel
            }
        default:
            break
        }
    }
    
    //MARK: - Public Functions
    func setupNavigationView(isHidden: Bool, isTranslucent: Bool? = true) {
        //: right items
        self.navigationController?.navigationBar.isHidden = isHidden
        let tryForFreeBtn = UIBarButtonItem(customView: self.tryForFreeButtonOutlet)
        self.navigationItem.rightBarButtonItem = tryForFreeBtn
        //: left item
        let viewNameLabel = UIBarButtonItem(customView: self.topTitle)
        self.navigationItem.leftBarButtonItem = viewNameLabel
        //: navigation view
        self.navigationController?.navigationBar.isTranslucent = isTranslucent ?? false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ViewBlackBG")
        //: visible
        self.tryForFreeButtonOutlet.fadeIn()
        self.topTitle.fadeIn()
    }
    
    //MARK: - Actions
}

extension QuotesVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView
        {
            case self.quotesFirstCollectionView:
                return self.templateSections[0].templates?.count ?? 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.quotesFirstCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotesCVC", for: indexPath) as! QuotesCVC
                guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
                cell.data = data
            
                self.scrollView.sizeMatching = .Dynamic(
                    width: {
                        self.view.frame.width
                    },
                    height: {
                        self.quotesFirstCollectionView.contentSize.height + 200
                    }
                )
            
                if indexPath.row > 3 && !self.isLoaded
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.quotesFirstCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                        self.quotesFirstCollectionView.fadeIn()
                        self.isLoaded = true
                    }
                }
            
                cell.addTransform()
                return cell
            default:
                return UICollectionViewCell()
        }
    }
}

extension QuotesVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView
        {
            case self.quotesFirstCollectionView:
                return CGSize(width: (self.view.frame.width / 1.7) - 40, height: 280)
            default:
                return collectionViewLayout.collectionViewContentSize
        }
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView
         {
             case self.quotesFirstCollectionView:
                 if UIDevice.modelName == "iPhone 8" {
                     
                     return UIEdgeInsets(top: 0, left: 18, bottom: 16, right: 18)
                 } else if UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 6" {
                     
                     return UIEdgeInsets(top: 0, left: 18, bottom: 16, right: 18)
                 } else {
                     
                     return UIEdgeInsets(top: 0, left: 23, bottom: 16, right: 23)
                 }
             default:
                 return UIEdgeInsets()
         }
     }
}
