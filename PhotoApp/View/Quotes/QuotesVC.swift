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
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            //: navigation bar
            self.navigationController?.setNavigationBarHidden(true, animated: false)
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
                width: { self.view.frame.width   },
                height: { 900 }
            )
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions

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
}
