//
//  SectionSeeAllViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

class SectionSeeAllViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(topPadding: 20, leftPadding: 16, bottomPadding: 20, rightPadding: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    var sections: [TemplateSection]?

    private let numberOfItemsInRows: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !LocalStorageManager.shared.isPremiumUser {
            var title = "Unlock Premium"

            if Constants().shouldUpdate == false {
                title = "Try for free"
            }

            if Constants().shouldUpdate == false && Constants().inAppPurchaseData?.isWeeklyGiftActive == true {
                title = "Claim your gift 🎁"
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(rightNavigationBarButtonItemTapped))
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func prepareUI() {
        view.backgroundColor = UIColor(hexString: "#1C1F21")
        navigationController?.view.backgroundColor = UIColor(hexString: "#1C1F21")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        view.addSubview(collectionView)
        collectionView.register(ImageCollectionViewCell.self)
        setupLayout()
        setupNavigationBar()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: nil) { (_) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                var title = "Unlock Premium"

                if Constants().shouldUpdate == false {
                    title = "Try for free"
                }
                
                if Constants().shouldUpdate == false && Constants().inAppPurchaseData?.isWeeklyGiftActive == true {
                    title = "Claim your gift 🎁"
                }
                self.navigationItem.rightBarButtonItem = LocalStorageManager.shared.isPremiumUser ? nil : UIBarButtonItem(title: title, style: .done, target: self, action: #selector(self.rightNavigationBarButtonItemTapped))
            }
        }
    }

    private func setupLayout() {
        collectionView.fillSuperview()
    }

    private func setupNavigationBar() {
        navigationItem.title = "Templates"
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#1C1F21")
        navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        navigationController!.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .medium),
            .foregroundColor: UIColor.white
        ]

        navigationController?.navigationBar.tintColor = .white
    }

    @objc func rightNavigationBarButtonItemTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        if Constants().shouldUpdate == false && Constants().inAppPurchaseData?.isWeeklyGiftActive == true {
            presentInFullScreen(SubscriptionGiftViewController(), animated: true)
        } else {
            presentInFullScreen(SubscriptionViewController(), animated: true, completion: nil)
        }
    }

}

extension SectionSeeAllViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections?[section].templates?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        guard let templates = self.sections?[indexPath.section].templates else { return UICollectionViewCell() }
        let template = templates[indexPath.item]
        cell.imageView.image = template.templateCoverImage
        if let isFree = template.isFree, isFree && !LocalStorageManager.shared.isPremiumUser {
            cell.freeBadgeView.isHidden = false
        } else {
            cell.freeBadgeView.isHidden = true
        }
        
        return cell
    }
}

extension SectionSeeAllViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator().impactOccurred()
        guard let template = self.sections?[indexPath.section].templates?[indexPath.item] else { return }
        let editorViewController = EditorViewController()
        editorViewController.template = template
        editorViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editorViewController, animated: true)
    }
}

extension SectionSeeAllViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let sectionHorizontalInsetSize = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let itemWidth = (collectionView.frame.width - (numberOfItemsInRows - 1.0) * flowLayout.minimumInteritemSpacing - sectionHorizontalInsetSize) / numberOfItemsInRows
        return CGSize(width: itemWidth, height: itemWidth / canvasRatio)
    }
}


