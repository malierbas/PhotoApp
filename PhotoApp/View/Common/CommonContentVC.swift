//
//  CommonContentVC.swift
//  PhotoApp
//
//  Created by Ali on 10.12.2021.
//

import UIKit

class CommonContentVC: BaseVC {
    //MARK: - Properties
    //: views
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var tryForFreeButton: UIButton!
    @IBOutlet weak var backButtonOutlet: UIButton!
    
    //: variables
    var categoryContentModel: CategoryContentModel!
    var isPost: Bool? = false
    var isLoaded = false
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        
        
        DispatchQueue.main.async {
            //: hide&setup navibar
            self.setupNavigationView(isHidden: true)
            //: collection
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
            self.collectionView.fadeOut()
            //: try for free btn
            self.tryForFreeButton.layer.cornerRadius = 14
            //: scroll view
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.isScrollEnabled = false
            //: setupView
            guard let categoryModel = self.categoryContentModel else { return }
            self.categoryNameLabel.text = categoryModel.contentName ?? "All Categories"
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    //MARK: - Public functions
    func calculateScrollHeight() -> CGFloat {
        var height: CGFloat = 280
        
        height = height + collectionView.contentSize.height
        
        return height
    }
        
    func setupNavigationView(isHidden: Bool? = false) {
        //: subviews
        if !isHidden!
        {
            let label = UIBarButtonItem(customView: self.categoryNameLabel)
            let button = UIBarButtonItem(customView: self.backButtonOutlet)
            let tryForFree = UIBarButtonItem(customView: self.tryForFreeButton)
            self.navigationItem.leftBarButtonItems = [button,label]
            self.navigationItem.rightBarButtonItem = tryForFree
            //: visible
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.backButtonOutlet.fadeIn()
                self.tryForFreeButton.fadeIn()
                self.categoryNameLabel.fadeIn()
            }
        }
        //: set navigation bar hidden
        self.navigationController?.navigationBar.isHidden = isHidden ?? true
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Delegates
extension CommonContentVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.categoryContentModel.contents?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.collectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonViewCVC", for: indexPath) as! CommonViewCVC
                cell.contentViewHeight.constant = self.isPost! ? 160 : 280
                cell.data = self.categoryContentModel.contents?[indexPath.row]
                cell.addTransform()
            
                if indexPath.row > 3 && !self.isLoaded
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                        self.collectionView.fadeIn()
                        self.isLoaded = true
                    }
                }
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.categoryContentModel.contents?[indexPath.row] else { return }
        UIImpactFeedbackGenerator().impactOccurred()
        let editorViewController = EditorViewController()
        editorViewController.template = data
        self.presentInFullScreen(editorViewController, animated: true, completion: nil)
    }
}

extension CommonContentVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView
        {
            case self.collectionView:
                return CGSize(width: (self.view.frame.width / 1.7) - 50, height: isPost! ? 160 : 280)
            default:
                return collectionViewLayout.collectionViewContentSize
        }
    }
     
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView
         {
             case self.collectionView:
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
