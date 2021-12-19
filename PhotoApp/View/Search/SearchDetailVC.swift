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
    @IBOutlet weak var storyCollectionView: UICollectionView!
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var highlightsCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: IKScrollView!
    @IBOutlet weak var tryForFreeBtnOutlet: UIButton!
    @IBOutlet weak var contentNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
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
            self.storyCollectionView.delegate = self
            self.storyCollectionView.dataSource = self
            
            self.postCollectionView.delegate = self
            self.postCollectionView.dataSource = self
            
            self.highlightsCollectionView.delegate = self
            self.highlightsCollectionView.dataSource = self
            
            self.storyCollectionView.reloadData()
            self.postCollectionView.reloadData()
            self.highlightsCollectionView.reloadData()
            //: scroll view
            self.scrollView.showsHorizontalScrollIndicator = false
            self.scrollView.showsVerticalScrollIndicator = false
            
            self.scrollView.sizeMatching = .Dynamic(
                width: { self.view.frame.width },
                height: { self.calculateScrollHeight() }
            )
        
            //: content model
            self.contentNameLabel.text = "Fashion"
        }
    }
     
    override func initListeners() {
        super.initListeners()
        
        DispatchQueue.main.async {
            
        }
    }
    
    //MARK: - Public Functions
    func calculateScrollHeight() -> CGFloat {
        var height: CGFloat = 400
        height = height + self.storyCollectionView.frame.height + self.postCollectionView.frame.height + self.highlightsCollectionView.frame.height
        return height
    }
    
    //MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Delegates
extension SearchDetailVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView
        {
            case self.storyCollectionView:
                return model?.count ?? 0
            case self.postCollectionView:
                return model?.count ?? 0
            case self.highlightsCollectionView:
                return model?.count ?? 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.storyCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchStoryCVC", for: indexPath) as! SearchStoryCVC
                guard let data = self.model?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
            
                self.scrollView.sizeMatching = .Dynamic(
                    width: { self.view.frame.width },
                    height: { self.calculateScrollHeight() }
                )
                cell.addTransform()
                return cell
            case self.postCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchPostCVC", for: indexPath) as! SearchPostCVC
                guard let data = self.model?[indexPath.row] else { return UICollectionViewCell() }
                cell.template = data
            
                self.scrollView.sizeMatching = .Dynamic(
                    width: { self.view.frame.width },
                    height: { self.calculateScrollHeight() }
                )
                cell.addTransform()
                return cell
            case self.highlightsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDetailCVC", for: indexPath) as! SearchDetailCVC
                guard let data = self.model?[indexPath.row] else { return UICollectionViewCell() }
                cell.data = data
            
                self.scrollView.sizeMatching = .Dynamic(
                    width: { self.view.frame.width },
                    height: { self.calculateScrollHeight() }
                )
                cell.addTransform()
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView
        {
            case self.highlightsCollectionView:
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
