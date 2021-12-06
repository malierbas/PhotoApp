//
//  CategoryDetailVC.swift
//  PhotoApp
//
//  Created by Ali on 17.11.2021.
//

import UIKit

class CategoryDetailVC: BaseVC {
    //MARK: - Properties
    //Views
    private let topBar: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "arrowBackIcon"), for: .normal)
        button.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let categoryDetailView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Sunset"
        label.font = UIFont(name: "Sailec-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryItemsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "405403 photos"
        label.font = UIFont(name: "Sailec-Regular", size: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Type here to Search"
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .clear
        return bar
    }()
    
    private lazy var categoryItemsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.register(CategoriesDetailCVC.self, forCellWithReuseIdentifier: "CategoriesDetailCVC")
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //Variables
    var model: TrendingCategoriesModel? = nil
    
    var allImages = [
        SuggestionsModel(itemID: 1, itemName: "Dummy hands", itemImage: "begum17-1"),
        SuggestionsModel(itemID: 2, itemName: "Dummy mountains", itemImage: "begum17"),
        SuggestionsModel(itemID: 3, itemName: "Dummy river", itemImage: "begum18-1"),
        SuggestionsModel(itemID: 4, itemName: "Dummy rainbow sky", itemImage: "begum18"),
        SuggestionsModel(itemID: 5, itemName: "Dummy black photo", itemImage: "begum19-1"),
        SuggestionsModel(itemID: 6, itemName: "Dummy rock in tree", itemImage: "begum20-1"),
        SuggestionsModel(itemID: 7, itemName: "Dummy 4 hands", itemImage: "vintage1-3"),
        SuggestionsModel(itemID: 8, itemName: "Dummy leafs", itemImage: "vintage1"),
        SuggestionsModel(itemID: 9, itemName: "Dummy nature img", itemImage: "begum4"),
        SuggestionsModel(itemID: 10, itemName: "Dummy draw img", itemImage: "vintage4-1")
    ]
    
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    
    var images = [SuggestionsModel]()
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        DispatchQueue.main.async { [self] in
            //: set navigation bar hidden
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            
            //View Background
            self.topBar.backgroundColor = .gray
            self.view.backgroundColor = .white
            
            //reload data
            self.images = self.allImages
            
            //addsubview
            self.view.addSubview(topBar)
            self.view.addSubview(searchBar)
            self.view.addSubview(categoryItemsCollectionView)
            self.topBar.addSubview(backButton)
            self.topBar.addSubview(categoryDetailView)
            self.categoryDetailView.addSubview(categoryImageView)
            self.categoryDetailView.addSubview(categoryLabel)
            self.categoryDetailView.addSubview(categoryItemsLabel)
            
            //Use Model
            categoryImageView.image = UIImage(named: model?.icon ?? "")
            categoryLabel.text = model?.categoryName ?? ""
            categoryItemsLabel.text = "\(model?.filterCount ?? 0) photos"
            
            //add constraints
            
            //top bar
            topBar.pinToTop()
            topBar.equalsToWidth()
            topBar.setHeight(size: 120)
            topBar.equalsToLeadings()
            topBar.equalsToTrailings()
            
            //back button
            backButton.pinToTopWithSize(with: 60)
            backButton.equalsToLeadings(with: 22)
            
            //category detail view
            categoryDetailView.setWidth(size: 131)
            categoryDetailView.setHeight(size: 50)
            categoryDetailView.centerXToSuperView(with: -20)
            categoryDetailView.pinToTopWithSize(with: 50)
            
            //category image view
            categoryImageView.setWidth(size: 47)
            categoryImageView.setHeight(size: 34)
            categoryImageView.equalsToLeadings()
            categoryImageView.centerYToSuperView()
            
            //category label
            categoryLabel.pinToTopWithSize(with: 5)
            categoryLabel.equalsLeadingToTrailing(view: categoryImageView, with: 11)
            
            //category items label
            categoryItemsLabel.pinTopToBottom(view: categoryLabel, with: 0)
            categoryItemsLabel.equalsLeadingToTrailing(view: categoryImageView, with: 11)
        
            //search bar
            searchBar.pinTopToBottom(view: topBar, with: 0)
            searchBar.equalsToLeadings()
            searchBar.equalsToTrailings()
            searchBar.delegate = self
            
            //collectionView
            categoryItemsCollectionView.pinTopToBottom(view: searchBar, with: 20)
            categoryItemsCollectionView.pinToBottom()
            categoryItemsCollectionView.equalsToLeadings()
            categoryItemsCollectionView.equalsToTrailings()
            categoryItemsCollectionView.reloadData()
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
//        DispatchQueue.main.async {
//            let startColor = UIColor().hexStringToUIColor(hex: self.model?.backgrodundColors?.first ?? "")
//            let endColor = UIColor().hexStringToUIColor(hex: self.model?.backgrodundColors?.last ?? "")
//
//            self.topBar.applyGradient(colours: [startColor, endColor])
//        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //do something
        }
    }
}


//MARK: - CollectionView, Delegate & DataSource
extension CategoryDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.templateSections[2].templates?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case categoryItemsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesDetailCVC", for: indexPath) as! CategoriesDetailCVC
                let data = self.templateSections[2].templates![indexPath.row]
                cell.itemImageView.image = data.templateCoverImage
                cell.itemDescriptionLabel.text = "item \(indexPath.row)"
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView
        {
            case self.categoryItemsCollectionView:
            
                UIImpactFeedbackGenerator().impactOccurred()
                let data = self.templateSections[2].templates![indexPath.row]
                let editorViewController = EditorViewController()
                editorViewController.template = data
                editorViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(editorViewController, animated: true)
            default:
                print("default")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView
        {
            case self.categoryItemsCollectionView:
                if UIDevice.modelName == "iPhone 8" {
                    
                    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                } else if UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 6" {
                    
                    return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                } else {
                    
                    return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                }
            default:
                return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView
        {
            case self.categoryItemsCollectionView:
                return CGSize(width: (self.view.frame.width / 2) - 20, height: 300)
            default:
                return CGSize()
        }
    }
}

//MARK: - Searchbar Delegates
extension CategoryDetailVC: UISearchBarDelegate {
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
         images = allImages.filter { $0.itemName!.contains(searchText.lowercased()) }

         if searchBar.text?.count == 0 { 

             DispatchQueue.main.async {
                 self.images = self.allImages
                 self.categoryItemsCollectionView.reloadData()
                 
                 searchBar.resignFirstResponder()
             }
         }

         categoryItemsCollectionView.reloadData()
     }
}
