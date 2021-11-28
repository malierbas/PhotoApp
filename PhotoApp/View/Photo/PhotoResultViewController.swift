//
//  PhotoResultViewController.swift
//  PhotoApp
//
//  Created by Ali on 20.11.2021.
//

import UIKit

class PhotoResultViewController: BaseVC {
    //MARK: - Properties
    //Views
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var effectImageView: UIImageView!
    @IBOutlet weak var effectsCollectionView: UICollectionView!
    
    //Variables
    var selectedImage: UIImage?
    
    var dataModel = [
        SuggestionsModel(itemID: 1, itemName: "Dummy hands", itemImage: "dummy1"),
        SuggestionsModel(itemID: 2, itemName: "Dummy mountains", itemImage: "dummy2"),
        SuggestionsModel(itemID: 3, itemName: "Dummy river", itemImage: "dummy3"),
        SuggestionsModel(itemID: 4, itemName: "Dummy rainbow sky", itemImage: "dummy4"),
        SuggestionsModel(itemID: 5, itemName: "Dummy black photo", itemImage: "dummy5"),
        SuggestionsModel(itemID: 6, itemName: "Dummy rock in tree", itemImage: "dummy6"),
        SuggestionsModel(itemID: 7, itemName: "Dummy 4 hands", itemImage: "dummy7"),
        SuggestionsModel(itemID: 8, itemName: "Dummy leafs", itemImage: "dummy8"),
        SuggestionsModel(itemID: 9, itemName: "Dummy nature img", itemImage: "dummy9"),
        SuggestionsModel(itemID: 10, itemName: "Dummy draw img", itemImage: "dummy10")
    ]
    
    //MARK: - LifeCycle
    override func setupView() {
        super.setupView()
        
        DispatchQueue.main.async { [self] in
            //nextButton
            nextButton.backgroundColor = .clear
            nextButton.layer.borderColor = UIColor(named: "SoftOrange")?.cgColor
            nextButton.layer.borderWidth = 1
            nextButton.layer.cornerRadius = 15
            
            //resultContainerView
            resultContainerView.layer.cornerRadius = 18 
            
            //CollectionView
            effectsCollectionView.delegate = self
            effectsCollectionView.dataSource = self
            effectsCollectionView.reloadData()
            
            //set image
            effectImageView.layer.cornerRadius = 18
            guard let image = selectedImage else { return print("no image found!!") }
            effectImageView.image = image
        }
    }
    
    override func initListeners() {
        super.initListeners()
        
        //backButton
        self.backButton.addTarget(self, action: #selector(self.backButtonAction(_:)), for: .touchUpInside)
        
        //: Next button
        self.nextButton.addTarget(self, action: #selector(self.nextButtonAction(_:)), for: .touchUpInside)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShareViewController" {
            guard let viewController = segue.destination as? ShareVC else { return }
            viewController.selectedImage = self.effectImageView.image
        }
    }
    
    //MARK: - Public Functions
    
    //MARK: - Actions
    @objc func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //do something
        }
    }
    
    @objc func nextButtonAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showShareViewController", sender: nil)
        }
    }
}

//MARK: - CollectionView, DataSource & Delegate
extension PhotoResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
            case self.effectsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EffectsCVC", for: indexPath) as! EffectsCVC
                cell.data = self.dataModel[indexPath.row]
                return cell
            default:
                return UICollectionViewCell()
        }
    }
}

