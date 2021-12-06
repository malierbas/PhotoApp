//
//  SectionSelectionView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

protocol SectionSelectionViewDelegate: class {
    func didSelectSection(atIndex index: Int, onView view: SectionSelectionView)
}

class SectionSelectionView: UIView {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = false
        return collectionView
    }()

    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.estimatedItemSize = CGSize(width: 60, height: 32)
        flowLayout.sectionInset = .init(topPadding: 8, leftPadding: 20, bottomPadding: 8, rightPadding: 20)
        return flowLayout
    }()

    var sections: [BackgroundType] {
        didSet {
            collectionView.reloadData()
        }
    }

    var selectedBackgroundType: BackgroundType = .color {
        didSet {
            if let oldSelectedIndex = sections.firstIndex(of: oldValue) {
                collectionView.deselectItem(at: IndexPath(item: oldSelectedIndex, section: 0), animated: true)
            }

            if let selectedIndex = sections.firstIndex(of: selectedBackgroundType) {
                collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }

    weak var delegate: SectionSelectionViewDelegate?

    init(sections: [BackgroundType]) {
        self.sections = sections
        super.init(frame: .zero)
        prepareUI()
    }

    override init(frame: CGRect) {
        self.sections = []
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareUI() {
        addSubview(collectionView)
        collectionView.register(SectionCollectionViewCell.self)
        setupLayout()

        if let selectedIndex = sections.firstIndex(of: selectedBackgroundType) {
            collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }

    }

    private func setupLayout() {
        collectionView.fillSuperview()
    }

}

extension SectionSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCollectionViewCell.reuseIdentifier, for: indexPath) as? SectionCollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = sections[indexPath.item].rawValue
        return cell
    }
}

extension SectionSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator().impactOccurred()
        selectedBackgroundType = sections[indexPath.item]
        self.delegate?.didSelectSection(atIndex: indexPath.item, onView: self)
    }
}

extension SectionSelectionView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
