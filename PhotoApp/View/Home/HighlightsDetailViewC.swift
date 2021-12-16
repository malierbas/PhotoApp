//
//  HighlightsDetailViewC.swift
//  PhotoApp
//
//  Created by Ali on 16.12.2021.
//

import UIKit

class HighlightsDetailViewC: BaseVC {
    //MARK: - Properties
    //: views
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var tryForFreeButton: UIButton!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var categoryNameTitle: UILabel!
    
    //: variables
    var categoryContentModel: CategoryContentModel? = nil
    var isPost: Bool? = false
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            //: transform
            self.view.addTransform()
            self.scrollView.addTransform()
            //: hide navibar
            self.setupNavigationView(isHidden: false)
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
            self.categoryNameTitle.text = categoryModel.contentName ?? "All Categories"
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
        var height: CGFloat = 280
        
        height = height + collectionView.contentSize.height
        
        return height
    }
        
    func setupNavigationView(isHidden: Bool? = false) {
        //: subviews
        let label = UIBarButtonItem(customView: self.categoryNameLabel)
        let button = UIBarButtonItem(customView: self.backButtonOutlet)
        let tryForFree = UIBarButtonItem(customView: self.tryForFreeButton)
        self.navigationItem.leftBarButtonItems = [button,label]
        self.navigationItem.rightBarButtonItem = tryForFree
        self.navigationController?.navigationBar.isHidden = isHidden ?? false
        //: visible
        self.backButtonOutlet.fadeIn()
        self.tryForFreeButton.fadeIn()
        self.categoryNameLabel.fadeIn()
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Delegates
extension HighlightsDetailViewC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = self.categoryContentModel?.contents?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.collectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightDetailCVC", for: indexPath) as! HighlightDetailCVC
                cell.data = self.categoryContentModel?.contents?[indexPath.row]
            
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
                cell.addTransform()
                return cell
            default:
                return UICollectionViewCell()
        }
    }
}
