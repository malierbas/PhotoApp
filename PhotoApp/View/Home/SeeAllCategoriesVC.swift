//
//  SeeAllCategoriesVC.swift
//  PhotoApp
//
//  Created by Ali on 10.12.2021.
//

import UIKit

class SeeAllCategoriesVC: BaseVC {
    //MARK: - Properties
    //: views
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var tryForFreeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //: variables
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    var mainArray: [Template]? = nil
    
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
            //: searchbar
            self.searchBar.delegate = self
            //: try for free btn
            self.tryForFreeButton.layer.cornerRadius = 14
            //: scroll view
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            //: set main array
            self.mainArray = self.templateSections[0].templates
            //: setupView
            guard let categoryModel = self.categoryContentModel else { return }
            self.categoryName.text = categoryModel.contentName ?? "Content"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.mainArray?.removeAll()
    }

    override func setupView() {
        super.setupView()
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case "showContentFirst":
            if let vc = segue.destination as? CommonContentVC
            {
                vc.categoryContentModel = self.categoryContentModel
            }
        default:
            break
        }
    }

    //MARK: - Public Functions
    func calculateScrollHeight() -> CGFloat {
        var height: CGFloat = 200
        
        height = height + collectionView.contentSize.height
        
        return height
    }
    
    
    //MARK: - Actions
}

//MARK: - Delegates
extension SeeAllCategoriesVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
        case self.collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeAllCategoriesCVC", for: indexPath) as! SeeAllCategoriesCVC
            
            cell.data = mainArray?[indexPath.row]
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView
        {
        case self.collectionView:
            DispatchQueue.main.async {
                self.categoryContentModel = CategoryContentModel(contentName: "Category \(indexPath.row)", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                self.performSegue(withIdentifier: "showContentFirst", sender: nil)
            }
        default:
            break
        }
    }
}

extension SeeAllCategoriesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        mainArray = self.templateSections[0].templates?.filter { ($0.canvasTexts?[0].text?.contains(String(searchText.lowercased())))! }
//
//        if searchBar.text?.count == 0 {
//
//            DispatchQueue.main.async {
//                self.mainArray = self.templateSections[0].templates
//                self.collectionView.reloadData()
//
//                searchBar.resignFirstResponder()
//            }
//        }
//
//        self.collectionView.reloadData()
    }
}
