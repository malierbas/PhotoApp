//
//  StickerSelectionViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

protocol StickerSelectionViewControllerDelegate: class {
    func didSelectStickerImage(sticker: Sticker, onViewController viewController: StickerSelectionViewController)
}

class StickerSelectionViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hexString: "#131314")
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.layer.cornerRadius = 32
        scrollView.clipsToBounds = true
        scrollView.delegate = self
        return scrollView
    }()

    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#DBDBDB").withAlphaComponent(0.6)
        view.layer.cornerRadius = 1.5
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let titleSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#CDCDCD")
        view.isHidden = true
        return view
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.lightGray
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = true
        return collectionView
    }()

    private let flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .init(topPadding: 24, leftPadding: 32, bottomPadding: 24, rightPadding: 32)
        flowLayout.minimumInteritemSpacing = 40
        flowLayout.minimumLineSpacing = 40
        return flowLayout
    }()

    private var scrollViewBottomConstraint: NSLayoutConstraint!

    weak var delegate: StickerSelectionViewControllerDelegate?

    var isScrollViewAnimating: Bool = false

    private let numberOfItemsPerRow: CGFloat = 2

    var stickers = [
        Sticker(image:UIImage(named: "new-stickers-3"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-1"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-4"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-6"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-8"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-7"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-10"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-2"), isFree: true),
        Sticker(image:UIImage(named: "new-stickers-9"), isFree: true),
        Sticker(image:UIImage(named: "pink_hand_painted_love_2"), isFree: true),
        Sticker(image:UIImage(named: "pink_hand_painted_love"), isFree: true),
        Sticker(image:UIImage(named: "group1"), isFree: true),
        Sticker(image:UIImage(named: "paper clip1"), isFree: true),
        Sticker(image:UIImage(named: "paper clip2"), isFree: true),
        Sticker(image:UIImage(named: "pintle"), isFree: true),
        Sticker(image:UIImage(named: "band1"), isFree: true),
        Sticker(image:UIImage(named: "band2"), isFree: true),
        Sticker(image:UIImage(named: "band3"), isFree: true),
        Sticker(image:UIImage(named: "band4"), isFree: true),
        Sticker(image:UIImage(named: "band5"), isFree: true),
        Sticker(image:UIImage(named: "band6"), isFree: true),
        Sticker(image:UIImage(named: "band7"), isFree: true),
        Sticker(image:UIImage(named: "band8"), isFree: true),
        Sticker(image:UIImage(named: "band9"), isFree: true),
        Sticker(image:UIImage(named: "band10"), isFree: true),
        Sticker(image:UIImage(named: "band11"), isFree: true),
        Sticker(image:UIImage(named: "gold1"), isFree: true),
        Sticker(image:UIImage(named: "gold2"), isFree: true),
        Sticker(image:UIImage(named: "gold3"), isFree: true),
        Sticker(image:UIImage(named: "gold4"), isFree: true),
        Sticker(image:UIImage(named: "gold5"), isFree: true),
        Sticker(image:UIImage(named: "gold6"), isFree: true),
        Sticker(image:UIImage(named: "gold7"), isFree: true),
        Sticker(image:UIImage(named: "gold8"), isFree: true),
        Sticker(image:UIImage(named: "gold9"), isFree: true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    private func prepareUI() {
        view.backgroundColor = UIColor.clear
        view.addSubview(scrollView)
        scrollView.addSubview(topLineView)
        scrollView.addSubview(closeButton)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleSeparatorLineView)
        scrollView.addSubview(collectionView)

        titleLabel.text = "Stickers"

        collectionView.register(StickerCollectionViewCell.self)

        // add swipe down gesture
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGestureRecognized))
        swipeDownGesture.direction = .down
        scrollView.addGestureRecognizer(swipeDownGesture)

        if Constants().shouldUpdate == nil || Constants().shouldUpdate == false {
            stickers.insert(Sticker(image:UIImage(named: "new-stickers-12")), at: 0)
            stickers.insert(Sticker(image:UIImage(named: "new-stickers-5")), at: 0)
        }
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateScrollView(withCompletion: nil)
    }

    private func setupLayout() {
        scrollView.anchor(leading: view.leadingAnchor,
                          trailing: view.trailingAnchor)
        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        scrollViewBottomConstraint.isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 1.5).isActive = true

        topLineView.anchor(top: scrollView.topAnchor, padding: .init(topPadding: 14))
        topLineView.anchorCenterXToSuperview()
        topLineView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 3).isActive = true

        closeButton.anchor(top: scrollView.topAnchor,
                           trailing: view.trailingAnchor, padding: .init(topPadding: 16, rightPadding: 16))
        closeButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 36).isActive = true

        titleLabel.anchor(top: scrollView.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: closeButton.leadingAnchor, padding: .init(topPadding: 30, leftPadding: 22, rightPadding: 10))

        titleSeparatorLineView.anchor(top: titleLabel.bottomAnchor,
                                      leading: view.leadingAnchor,
                                      trailing: view.trailingAnchor, padding: .init(topPadding: 16))
        titleSeparatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        collectionView.anchor(top: titleSeparatorLineView.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              bottom: view.bottomAnchor,
                              padding: .zero)

        view.layoutIfNeeded()
        scrollViewBottomConstraint.constant = scrollView.frame.height

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: scrollView)
        let userBufferInPointsToMistakenlyTapAboveScrollView: CGFloat = 20
        if (touchLocation.y < -userBufferInPointsToMistakenlyTapAboveScrollView) { // empty space area tapped.
            closeButtonTapped()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 && !isScrollViewAnimating {
            animateScrollView(withCompletion: nil)
        }
    }

    private func animateScrollView(withCompletion completion: ((_ success: Bool) -> ())?) {
        view.layoutIfNeeded()
        if self.scrollViewBottomConstraint.constant > 0 { // should show
            self.scrollViewBottomConstraint.constant = 0
            isScrollViewAnimating = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.view.layoutIfNeeded()
                }, completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.isScrollViewAnimating = false
            })
        } else { // should hide
            isScrollViewAnimating = true
            self.scrollViewBottomConstraint.constant = self.scrollView.bounds.height
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.titleLabel.alpha = 0
                self.view.layoutIfNeeded()
            }) {[weak self] _ in
                guard let self = self else { return }
                self.isScrollViewAnimating = false
                self.dismiss(animated: false, completion: nil)
            }
        }
    }

    @objc func closeButtonTapped() {
        animateScrollView(withCompletion: nil)
    }

    @objc func swipeDownGestureRecognized(_ gestureRecognizer: UISwipeGestureRecognizer) {
        animateScrollView(withCompletion: nil)
    }
}


extension StickerSelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.reuseIdentifier, for: indexPath) as? StickerCollectionViewCell else { return UICollectionViewCell() }
        cell.sticker = stickers[indexPath.item]
        return cell
    }
}

extension StickerSelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selecetedSticker = stickers[indexPath.item]
        self.delegate?.didSelectStickerImage(sticker: selecetedSticker, onViewController: self)
        animateScrollView(withCompletion: nil)
    }
}

extension StickerSelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalPaddingsTotal = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing
        let widthPerItem = (collectionView.frame.width - horizontalPaddingsTotal) / numberOfItemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

