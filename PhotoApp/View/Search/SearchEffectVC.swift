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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryItemsCollectionView: UICollectionView!
    
    //Variables
    var model: TrendingCategoriesModel? = nil
    
    var allImages = [
        SuggestionsModel(itemID: 1, itemName: "Dummy hands 1", itemImage: "dummy1"),
        SuggestionsModel(itemID: 2, itemName: "Dummy mountains 2", itemImage: "dummy2"),
        SuggestionsModel(itemID: 3, itemName: "Dummy river 3", itemImage: "dummy3"),
        SuggestionsModel(itemID: 4, itemName: "Dummy rainbow sky 4", itemImage: "dummy4"),
        SuggestionsModel(itemID: 5, itemName: "Dummy black photo 5", itemImage: "dummy5"),
        SuggestionsModel(itemID: 6, itemName: "Dummy rock in tree 6", itemImage: "dummy6"),
        SuggestionsModel(itemID: 7, itemName: "Dummy 4 hands 7", itemImage: "dummy7"),
        SuggestionsModel(itemID: 8, itemName: "Dummy leafs 8", itemImage: "dummy8"),
        SuggestionsModel(itemID: 9, itemName: "Dummy nature img 9", itemImage: "dummy9"),
        SuggestionsModel(itemID: 10, itemName: "Dummy draw img 10", itemImage: "dummy10")
    ]
    
    
    var images = [SuggestionsModel]()
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        DispatchQueue.main.async { [self] in
            
            //reload data
            self.images = self.allImages
 
            //search bar
            self.searchBar.delegate = self
            self.searchBar.barTintColor = UIColor.clear
            self.searchBar.backgroundColor = UIColor.clear
            self.searchBar.isTranslucent = true
            self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            
            //: collectionView
            self.categoryItemsCollectionView.delegate = self
            self.categoryItemsCollectionView.dataSource = self
            self.categoryItemsCollectionView.register(SearchCVC.self, forCellWithReuseIdentifier: "SearchCVC")
            self.categoryItemsCollectionView.reloadData()
        }
    }
    
    override func initListeners() {
        super.initListeners()
    }
    
    //MARK: - Public Functions 
}


//MARK: - CollectionView, Delegate & DataSource
extension SearchEffectVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case categoryItemsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCVC", for: indexPath) as! SearchCVC
                cell.itemImageView.image = UIImage(named: self.images[indexPath.row].itemImage ?? "")
                cell.itemDescriptionLabel.text = self.images[indexPath.row].itemName ?? ""
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
                return CGSize(width: (self.view.frame.width / 2) - 40, height: 160)
            default:
                return CGSize()
        }
    }
}

//MARK: - Searchbar Delegates
extension SearchEffectVC: UISearchBarDelegate {
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
         images = allImages.filter { $0.itemName!.contains(String(searchText.lowercased())) }

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
