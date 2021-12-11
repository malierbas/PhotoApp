//
//  SearchDetailVC.swift
//  PhotoApp
//
//  Created by Ali on 11.12.2021.
//

import UIKit

class SearchDetailVC: BaseVC {
    //MARK: - Properties
    //: Views
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var tryForFreeBtnOutlet: UIButton!
    
    //: Variables
    var templateSections: [TemplateSection] = [
        TemplateSection(title: "Classic", templates: Template.generateMinimalModels(), hasSeeAllButton: true),
        TemplateSection(title: "Vintage", templates: Template.generateVintageModels(), hasSeeAllButton: true),
        TemplateSection(title: "Frame", templates: Template.generateFrameModels(), hasSeeAllButton: true)
    ]
    
    var model: [Template]? = nil
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async {
            //: navigation bar
            self.navigationController?.navigationBar.isHidden = true
            //: set model
            self.model = self.templateSections[0].templates?.shuffled()
            //: try for free btn
            self.tryForFreeBtnOutlet.layer.cornerRadius = 14
            //: collection view
            self.detailCollectionView.delegate = self
            self.detailCollectionView.dataSource = self
            self.detailCollectionView.reloadData()
            //: scroll view
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
        }
    }
     
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    //MARK: - Public Functions
    func calculateScrollHeight() -> CGFloat {
        var height: CGFloat = 200
        height = height + self.detailCollectionView.contentSize.height
        return height
    }
    
    //MARK: - Actions

}

//MARK: - Delegates
extension SearchDetailVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView
        {
            case self.detailCollectionView:
                return model?.count ?? 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.detailCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDetailCVC", for: indexPath) as! SearchDetailCVC
                guard let data = self.model?[indexPath.row] else { return UICollectionViewCell() }
                cell.data = data
            
                self.scrollView.sizeMatching = .Dynamic(
                    width: { self.view.frame.width },
                    height: { self.calculateScrollHeight() }
                )
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView
        {
            case self.detailCollectionView:
                guard let data = self.model?[indexPath.row] else { return }
                UIImpactFeedbackGenerator().impactOccurred()
                let editorViewController = EditorViewController()
                editorViewController.template = data
                self.presentInFullScreen(editorViewController, animated: true, completion: nil)
                
            default:
                break
        }
    }
}
