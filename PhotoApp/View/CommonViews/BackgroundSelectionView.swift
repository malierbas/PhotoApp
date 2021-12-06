//
//  BackgroundSelectionView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//


import UIKit

protocol BackgroundSelectionViewDelegate: class {
    func didSelectBackground(background: Background, onView view: BackgroundSelectionView)
}

class BackgroundSelectionView: UIView {

    lazy var collectionView: UICollectionView = {
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
        flowLayout.sectionInset = .init(topPadding: 8, leftPadding: 20, bottomPadding: 8, rightPadding: 20)
        return flowLayout
    }()

    var backgrounds: [Background] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    weak var delegate: BackgroundSelectionViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func prepareUI() {
        addSubview(collectionView)
        collectionView.register(BackgroundCollectionViewCell.self)
        setupLayout()
    }

    private func setupLayout() {
        collectionView.fillSuperview()
    }

}

extension BackgroundSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgrounds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCollectionViewCell.reuseIdentifier, for: indexPath) as? BackgroundCollectionViewCell else { return UICollectionViewCell() }
        cell.background = backgrounds[indexPath.row]
        return cell
    }
}

extension BackgroundSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didSelectBackground(background: backgrounds[indexPath.item], onView: self)
    }
}

extension BackgroundSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

