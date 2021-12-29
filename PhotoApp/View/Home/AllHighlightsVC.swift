//
//  SeeAllCategoriesVC.swift
//  PhotoApp
//
//  Created by Ali on 10.12.2021.
//

import UIKit

class AllHighlightsVC: BaseVC {
    //MARK: - Properties
    //: views
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var tryForFreeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var thirdCollectionView: UICollectionView!
    @IBOutlet weak var fourthCollectionView: UICollectionView!
    
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
            self.setupNavigationView(isHidden: true)
            //: collection
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            
            self.secondCollectionView.dataSource = self
            self.secondCollectionView.delegate = self
            
            self.thirdCollectionView.dataSource = self
            self.thirdCollectionView.delegate = self
            
            self.fourthCollectionView.dataSource = self
            self.fourthCollectionView.delegate = self
            
            self.collectionView.reloadData()
            self.secondCollectionView.reloadData()
            self.thirdCollectionView.reloadData()
            self.fourthCollectionView.reloadData()
            
            //: try for free btn
            self.tryForFreeButton.layer.cornerRadius = 14
            //: scroll view
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            //: setupView
            guard let categoryModel = self.categoryContentModel else { return }
            self.categoryName.text = categoryModel.contentName ?? "Content"
            //: set main array
            self.mainArray = categoryModel.contents
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
        case "showDetailCAtegory":
            if let vc = segue.destination as? HighlightsDetailViewC
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
        
        height = 900
        
        return height
    }
    
    func setupNavigationView(isHidden: Bool? = false) {
        //: subviews
        if !isHidden!
        {
            let label = UIBarButtonItem(customView: self.categoryName)
            let button = UIBarButtonItem(customView: self.backButtonOutlet)
            let tryForFree = UIBarButtonItem(customView: self.tryForFreeButton)
            self.navigationItem.leftBarButtonItems = [button,label]
            self.navigationItem.rightBarButtonItem = tryForFree
            //: visible
            self.tryForFreeButton.fadeIn()
            self.categoryName.fadeIn()
            self.backButtonOutlet.fadeIn()
        }
        
        //: set visible
        self.navigationController?.navigationBar.isHidden = isHidden ?? true
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonACtion(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seeAllFirstAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.categoryContentModel = CategoryContentModel(contentName: "Çalışma ve Üretkenlik", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
        }
    }
    
    @IBAction func seeAllSecondAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.categoryContentModel = CategoryContentModel(contentName: "Kişisel Gelişim", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
        }
    }
    
    @IBAction func seeAllThirdAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.categoryContentModel = CategoryContentModel(contentName: "Sağlıklı Yaşam", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
        }
    }
    
    @IBAction func seeAllFourthAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.categoryContentModel = CategoryContentModel(contentName: "Modernist", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
            self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
        }
    }
}

//MARK: - Delegates
extension AllHighlightsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.collectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeAllCategoriesCVC", for: indexPath) as! AllHighlightCVC
                
                cell.data = mainArray?[indexPath.row]
                cell.addTransform()
                
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
                
            case self.secondCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllHighlightSecondCVC", for: indexPath) as! AllHighlightSecondCVC
                
                cell.data = mainArray?[indexPath.row]
                cell.addTransform()
                
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
                
            case self.thirdCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllHighlightThirtCVC", for: indexPath) as! AllHighlightThirtCVC
                
                cell.data = mainArray?[indexPath.row]
                cell.addTransform()
                
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
            case self.fourthCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllHighlightFourthCVC", for: indexPath) as! AllHighlightFourthCVC
                
                cell.data = mainArray?[indexPath.row]
                cell.addTransform()
                
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
                    self.categoryContentModel = CategoryContentModel(contentName: "Çalışma ve Üretkenlik", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
                }
                
            case self.secondCollectionView:
                DispatchQueue.main.async {
                    self.categoryContentModel = CategoryContentModel(contentName: "Kişisel Gelişim", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
                }
                
            case self.thirdCollectionView:
                DispatchQueue.main.async {
                    self.categoryContentModel = CategoryContentModel(contentName: "Sağlıklı Yaşam", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
                }
                
            case self.fourthCollectionView:
                DispatchQueue.main.async {
                    self.categoryContentModel = CategoryContentModel(contentName: "Modernist", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
                    self.performSegue(withIdentifier: "showDetailCAtegory", sender: nil)
                }
            
            default:
                break
        }
    }
}

extension AllHighlightsVC: UISearchBarDelegate {
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
