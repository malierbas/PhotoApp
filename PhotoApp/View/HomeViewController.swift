//
//  ViewController.swift
//  PhotoApp
//
//  Created by Ali on 13.11.2021.
//

import UIKit

class HomeViewController: BaseVC {
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
        "dummy1",
        "dummy2",
        "dummy3",
        "dummy4",
        "dummy5",
        "dummy6",
        "dummy7",
        "dummy8",
        "dummy9",
        "dummy10"
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
    
    //MARK: - Public Functions
    //Calculate scroll size
    func calculateScrollSize() -> CGFloat {
        var height = CGFloat(100)
        
        height = height + self.topImageCollectionView.frame.height + self.trendingCategoriesCollectionview.frame.height + self.allUserPhotosCollectionView.contentSize.height + 300
        
        return height
    }
    //MARK: - Actions
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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopImageCVC", for: indexPath) as! TopImageCVC
                print("cell tag = ", cell.tag)
            case self.trendingCategoriesCollectionview:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCategoriesCVC", for: indexPath) as! TrendingCategoriesCVC
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let detailView = CategoryDetailVC()
                    detailView.model = self.trendingImagesItems[indexPath.row]
                    detailView.modalPresentationStyle = .fullScreen
                    self.present(detailView, animated: true, completion: nil)
                }
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
