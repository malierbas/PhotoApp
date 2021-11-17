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
        DispatchQueue.main.async { [self] in
            //View Background
            self.topBar.backgroundColor = .gray
            self.view.backgroundColor = .white
            
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
        
        DispatchQueue.main.async {
            let startColor = UIColor().hexStringToUIColor(hex: self.model?.backgrodundColors?.first ?? "")
            let endColor = UIColor().hexStringToUIColor(hex: self.model?.backgrodundColors?.last ?? "")
        
            self.topBar.applyGradient(colours: [startColor, endColor])
        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //do something
        }
    }
}

extension CategoryDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case categoryItemsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesDetailCVC", for: indexPath) as! CategoriesDetailCVC
                cell.itemImageView.image = UIImage(named: self.images[indexPath.row])
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch collectionView
        {
            case self.categoryItemsCollectionView:
                if UIDevice.modelName == "iPhone 8" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else if UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 6" {
                    
                    return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                } else {
                    
                    return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
                }
            default:
                return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView
        {
            case self.categoryItemsCollectionView:
                return CGSize(width: (self.view.frame.width / 2) - 40, height: 200)
            default:
                return CGSize()
        }
    }
}
