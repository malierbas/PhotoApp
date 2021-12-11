//
//  QuotesVC.swift
//  PhotoApp
//
//  Created by Ali on 11.12.2021.
//

import UIKit

class QuotesVC: BaseVC {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var tryForFreeButtonOutlet: UIButton!
    @IBOutlet weak var quotesFirstCollectionView: UICollectionView!
    @IBOutlet weak var quotesSecondCollectionView: UICollectionView!
    @IBOutlet weak var quotesThirdCollectionView: UICollectionView!
    
    //: Variables
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    
    var categoryContentModel: CategoryContentModel!
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            //: navigation bar
            self.navigationController?.navigationBar.isHidden = true
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
            //: collection views
            self.quotesFirstCollectionView.delegate = self
            self.quotesFirstCollectionView.dataSource = self
            self.quotesSecondCollectionView.dataSource = self
            self.quotesSecondCollectionView.delegate = self
            self.quotesThirdCollectionView.delegate = self
            self.quotesThirdCollectionView.dataSource = self
            self.quotesFirstCollectionView.reloadData()
            self.quotesSecondCollectionView.reloadData()
            self.quotesThirdCollectionView.reloadData()
            //: try for free btn
            self.tryForFreeButtonOutlet.layer.cornerRadius = 14
            //: scrollView
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.sizeMatching = .Dynamic(
                width: {
                    self.view.frame.width
                },
                height: {
                    900
                }
            )
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier
        {
        case "showDetailScreen":
            if let vc = segue.destination as? CommonContentVC
            {
                vc.categoryContentModel = self.categoryContentModel
            }
        default:
            break
        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions

    @IBAction func seeAllFirstAction(_ sender: Any) {
        self.categoryContentModel = CategoryContentModel(contentName: "Category 1", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
        self.performSegue(withIdentifier: "showDetailScreen", sender: nil)
    }
    
    @IBAction func seeAllSecondAction(_ sender: Any) {
        self.categoryContentModel = CategoryContentModel(contentName: "Category 2", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
        self.performSegue(withIdentifier: "showDetailScreen", sender: nil)
    }
    
    @IBAction func seeAllThirdAction(_ sender: Any) {
        self.categoryContentModel = CategoryContentModel(contentName: "Category 3", contentSize: self.templateSections[0].templates?.count ?? 0, contents: self.templateSections[0].templates)
        self.performSegue(withIdentifier: "showDetailScreen", sender: nil)
    }
}

extension QuotesVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView
        {
            case self.quotesFirstCollectionView:
                return self.templateSections[0].templates?.count ?? 0
            case self.quotesSecondCollectionView:
                return self.templateSections[0].templates?.count ?? 0
            case self.quotesThirdCollectionView:
                return self.templateSections[0].templates?.count ?? 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
        case self.quotesFirstCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotesCVC", for: indexPath) as! QuotesCVC
            guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
            cell.data = data
            return cell
        case self.quotesSecondCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotesSecondCVC", for: indexPath) as! QuotesSecondCVC
            guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
            cell.data = data
            return cell
        case self.quotesThirdCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotesThirdCVC", for: indexPath) as! QuotesThirdCVC
            guard let data = self.templateSections[0].templates?[indexPath.row] else { return UICollectionViewCell() }
            cell.data = data
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let data = self.templateSections[0].templates?[indexPath.row] else { return }
        UIImpactFeedbackGenerator().impactOccurred()
        let editorViewController = EditorViewController()
        editorViewController.template = data
        self.presentInFullScreen(editorViewController, animated: true, completion: nil)
    }
}
