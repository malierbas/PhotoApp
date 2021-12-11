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
    
    //: variables
    var categoryContentModel: CategoryContentModel!
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            //: hide navibar
            self.navigationController?.navigationBar.isHidden = true
            //: collection
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            //: try for free btn
            self.tryForFreeButton.layer.cornerRadius = 14
            //: scroll view
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            //: setupView
            guard let categoryModel = self.categoryContentModel else { return }
            self.categoryNameLabel.text = categoryModel.contentName ?? "All Categories"
        }
    }
    
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    //MARK: - Public functions
    func calculateScrollHeight() -> CGFloat {
        var height: CGFloat = 200
        
        height = height + collectionView.contentSize.height
        
        return height
    }
    
    //MARK: - Actions
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
                cell.data = self.categoryContentModel.contents?[indexPath.row]
            
                DispatchQueue.main.async {
                    self.scrollView.sizeMatching = .Dynamic(
                        width: {
                            self.view.frame.width
                        },
                        height: {
                            self.calculateScrollHeight()
                        }
                    )
                }
                return cell
            default:
                return UICollectionViewCell()
        }
    }
}
