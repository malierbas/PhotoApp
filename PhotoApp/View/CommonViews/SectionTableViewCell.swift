//
//  SectionTableViewCell.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

protocol SectionTableViewCellDelegate: class {
    func didSelectSeeAllButton(onCell cell: SectionTableViewCell)
    func didSelectCell(atIndexPath indexPath: IndexPath, onCell cell: SectionTableViewCell)
}

class SectionTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "Classic"
        label.textColor = UIColor.black.withAlphaComponent(0.95)
        return label
    }()
    
    lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See all", for: .normal)
        button.tintColor  = UIColor(hexString: "#939496")
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(topPadding: 8, leftPadding: 20, bottomPadding: 8, rightPadding: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    weak var delegate: SectionTableViewCellDelegate?

    var templates: [Template]?

    var collectionViewHeight: CGFloat = 360 {
        didSet {
            collectionViewHeightConstraint.constant = collectionViewHeight
            layoutIfNeeded()
        }
    }

    var collectionViewHeightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareUI()
    }
    
    private func prepareUI() {
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(seeAllButton)
        addSubview(collectionView)
        collectionView.register(ImageCollectionViewCell.self)
        setupLayout()
    }
    
    private func setupLayout() {
        titleLabel.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          trailing: seeAllButton.leadingAnchor,
                          padding: .init(topPadding: 16, leftPadding: 20, rightPadding: 8))
        seeAllButton.anchor(trailing: trailingAnchor,
                            padding: .init(rightPadding: 20))
        seeAllButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true

        collectionView.anchor(top: titleLabel.bottomAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor,
                              bottom: bottomAnchor,
                              padding: .init(topPadding: 8, bottomPadding: 8))
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
        collectionViewHeightConstraint.isActive = true
    }
    
    @objc func seeAllButtonTapped() {
        self.delegate?.didSelectSeeAllButton(onCell: self)
    }

}

extension SectionTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        guard let templates = templates else { return UICollectionViewCell() }
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

extension SectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectCell(atIndexPath: indexPath, onCell: self)
    }
}

extension SectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let height = collectionViewHeight - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
        return CGSize(width: height * canvasRatio,  height: height)
    }
}
