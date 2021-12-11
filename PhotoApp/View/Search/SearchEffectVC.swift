//
//  SearchEffectVC.swift
//  PhotoApp
//
//  Created by Ali on 20.11.2021.
//

import UIKit

class SearchEffectVC: BaseVC {
    //MARK: - Properties
    //Views
    @IBOutlet weak var categoryItemsCollectionView: UICollectionView!
    @IBOutlet weak var secondCategoryItemsCollectionView: UICollectionView!
    @IBOutlet weak var thirdCategoryItemsCollectionView: UICollectionView!
    @IBOutlet weak var tryForFreeButton: UIButton!
    
    //Variables
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    var model: [Template]? = nil
    
    var destinationModel: CategoryContentModel!
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
    
        DispatchQueue.main.async {
            //: set model
            self.model = self.templateSections[0].templates?.shuffled()
            //: navigation bar
            self.navigationController?.navigationBar.isHidden = true
            //: try for free btn
            self.tryForFreeButton.layer.cornerRadius = 14
            //: collectionViews
            self.categoryItemsCollectionView.delegate = self
            self.categoryItemsCollectionView.dataSource = self
        
            self.secondCategoryItemsCollectionView.delegate = self
            self.secondCategoryItemsCollectionView.dataSource = self
            
            self.thirdCategoryItemsCollectionView.delegate = self
            self.thirdCategoryItemsCollectionView.dataSource = self
            
            self.categoryItemsCollectionView.reloadData()
            self.secondCategoryItemsCollectionView.reloadData()
            self.thirdCategoryItemsCollectionView.reloadData()
        }
    }
    
    override func initListeners() {
        super.initListeners()
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
}


//MARK: - CollectionView, Delegate & DataSource
extension SearchEffectVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView
        {
            case self.categoryItemsCollectionView:
                return self.model?.count ?? 0
            case self.secondCategoryItemsCollectionView:
                return self.model?.count ?? 0
            case self.thirdCategoryItemsCollectionView:
                return self.model?.count ?? 0
            default:
                return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.categoryItemsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCVC", for: indexPath) as! SearchCVC
                cell.data = self.model?[indexPath.row]
                return cell
            case self.secondCategoryItemsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchSecondCVC", for: indexPath) as! SearchSecondCVC
                cell.data = self.model?[indexPath.row]
                return cell
            case self.thirdCategoryItemsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchThirdCVC", for: indexPath) as! SearchThirdCVC
                cell.data = self.model?[indexPath.row]
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.destinationModel = CategoryContentModel(contentName: "Category \(indexPath.row)", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
        self.performSegue(withIdentifier: "searchCategoryDetail", sender: nil)
    }
} 
