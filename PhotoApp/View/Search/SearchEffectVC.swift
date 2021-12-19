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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryItemsCollectionView: UICollectionView!
    @IBOutlet weak var tryForFreeButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    var model: [Template]? = nil
    
    var destinationModel: CategoryContentModel!
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            //: set model
            self.model = self.templateSections[0].templates?.shuffled()
            //: navigation bar
            self.setupNavigationView(isHidden: false)
            //: try for free btn
            self.tryForFreeButton.layer.cornerRadius = 14
            //: collectionViews
            self.categoryItemsCollectionView.delegate = self
            self.categoryItemsCollectionView.dataSource = self
            self.categoryItemsCollectionView.reloadData()
            //: hide keyboard
            self.hideKeyboardWhenTappedAround()
            //: search bar
            self.searchBar.layer.cornerRadius = self.searchBar.frame.height / 2
            self.searchBar.backgroundColor = .clear
        }
    }
    
    override func setupView() {
        super.setupView()
    }
    
    override func initListeners() {
        super.initListeners()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
            case "searchCategoryDetail":
                if let viewC = segue.destination as? AllHighlightsVC
                {
                    viewC.categoryContentModel = self.destinationModel
                }
                break
            default:
                break
        }
    }
    //MARK: - Public Functions
    //: navigation bar
    func setupNavigationView(isHidden: Bool, isTranslucent: Bool? = true) {
        //: right items
        self.navigationController?.navigationBar.isHidden = isHidden
        let tryForFreeBtn = UIBarButtonItem(customView: self.tryForFreeButton)
        self.navigationItem.rightBarButtonItem = tryForFreeBtn
        //: left item
        let viewNameLabel = UIBarButtonItem(customView: self.titleLabel)
        self.navigationItem.leftBarButtonItem = viewNameLabel
        //: navigation view
        self.navigationController?.navigationBar.isTranslucent = isTranslucent ?? false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "ViewBlackBG")
        //: visible
        self.tryForFreeButton.fadeIn()
        self.titleLabel.fadeIn()
        //: search bar
        self.searchBar.delegate = self
    }
    
    //MARK: - Action
}


//MARK: - CollectionView, Delegate & DataSource
extension SearchEffectVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView
        {
            case self.categoryItemsCollectionView:
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
                cell.addTransform()
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

extension SearchEffectVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView
        {
            case self.categoryItemsCollectionView:
                return CGSize(width: 100, height: 138)
            default:
                return CGSize(width: 0, height: 0)
        }
    }
}

extension SearchEffectVC: UISearchBarDelegate
{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.model = self.templateSections[0].templates?.filter {
            $0.templateName!.contains(String(searchText.lowercased()))
        }
        
        if searchBar.text?.count == 0 {

            DispatchQueue.main.async {
                self.model = self.templateSections[0].templates
                self.categoryItemsCollectionView.reloadData()

                searchBar.resignFirstResponder()
            }
        }

        self.categoryItemsCollectionView.reloadData()
    }
}
