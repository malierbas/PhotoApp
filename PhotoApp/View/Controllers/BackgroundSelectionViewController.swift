//
//  BackgroundSelectionViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

protocol BackgroundSelectionViewControllerDelegate: class {
    func didSelectBackground(background: Background, onViewController viewController: BackgroundSelectionViewController)
}

class BackgroundSelectionViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(hexString: "#131314")
        scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scrollView.layer.cornerRadius = 32
        scrollView.clipsToBounds = true
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

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.lightGray
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var backgroundSelectionView: BackgroundSelectionView = {
        let backgroundSelectionView = BackgroundSelectionView(frame: .zero)
        backgroundSelectionView.delegate = self
        backgroundSelectionView.backgrounds = self.backgrounds.filter({ $0.type == sectionSelectionView.selectedBackgroundType })
        return backgroundSelectionView
    }()

    private lazy var sectionSelectionView: SectionSelectionView = {
        let sectionSelectionView = SectionSelectionView(sections: BackgroundType.allCases)
        sectionSelectionView.delegate = self
        return sectionSelectionView
    }()

    var backgrounds: [Background] = [
        Background(image: UIImage(named: "marble1"), preview: UIImage(named: "marble1-preview"), isFree: false, type: .pattern),
        Background(image: UIImage(named: "marble2"), preview: UIImage(named: "marble2-preview"), isFree: false, type: .pattern),
        Background(image: UIImage(named: "marble3"), preview: UIImage(named: "marble3-preview"), type: .pattern),
        Background(image: UIImage(named: "bg-wood-dark"), preview: UIImage(named: "bg-wood-dark-preview"), isFree: false, type: .pattern),
        Background(image: UIImage(named: "bg-wood"), preview: UIImage(named: "bg-wood-preview"), isFree: false, type: .pattern),
        Background(image: UIImage(named: "bg-cimento"), preview: UIImage(named: "bg-cimento-preview"), type: .pattern),
        Background(image: UIImage(named: "darkbBlueWood"), preview: UIImage(named: "darkbBlueWood-preview"), type: .pattern),
        Background(image: UIImage(named: "lightBlueWall"), preview: UIImage(named: "lightBlueWall-preview"), type: .pattern),
        Background(image: UIImage(named: "lightWood"), preview: UIImage(named: "lightWood-preview"), type: .pattern),
        Background(image: UIImage(named: "greyBrickWall"), preview: UIImage(named: "greyBrickWall-preview"), type: .pattern),
        Background(image: UIImage(named: "lightPinkWall"), preview: UIImage(named: "lightPinkWall-preview"), type: .pattern),
        Background(image: UIImage(named: "darkPinkWall"), preview: UIImage(named: "darkPinkWall-preview"), type: .pattern),
        Background(image: UIImage(named: "rainDrop"), preview: UIImage(named: "rainDrop-preview"), isFree: false, type: .pattern),
        Background(image: UIImage(named: "darkRainDrops"), preview: UIImage(named: "darkRainDrops-preview"), type: .pattern),
        Background(image: UIImage(named: "greyWhiteWall"), preview: UIImage(named: "greyWhiteWall-preview"), type: .pattern),
        Background(image: UIImage(named: "flowersWall"), preview: UIImage(named: "flowersWall-preview"), isFree: false, type: .pattern),
        Background(image: UIImage(named: "feather"), preview: UIImage(named: "feather-preview"), type: .pattern),
        Background(image: UIImage(named: "begum9-1"), preview: UIImage(named: "begum9-1"), type: .pattern),
        
        Background(color: .black, type: .color),
        Background(color: UIColor(hexString: "#424242"), type: .color),
        Background(color: UIColor(hexString: "#9E9E9E"), type: .color),
        Background(color: UIColor(hexString: "#DBDBDB"), type: .color),
        Background(color: UIColor.white, type: .color),
        Background(color: UIColor(hexString: "#FEE57F"), type: .color),
        Background(color: UIColor(hexString: "#FDD83F"), type: .color),
        Background(color: UIColor(hexString: "#F9C432"), type: .color),
        Background(color: UIColor(hexString: "#F6AB32"), type: .color),
        Background(color: UIColor(hexString: "#DE412C"), type: .color),
        Background(color: UIColor(hexString: "#ED462F"), type: .color),
        Background(color: UIColor(hexString: "#F06C30"), type: .color),
        Background(color: UIColor(hexString: "#F39E80"), type: .color),
        Background(color: UIColor(hexString: "#FADDD0"), type: .color),
        Background(color: UIColor(hexString: "#C3F325"), type: .color),
        Background(color: UIColor(hexString: "#ECF641"), type: .color),
        Background(color: UIColor(hexString: "#F3F881"), type: .color),
        Background(color: UIColor(hexString: "#F8FAA6"), type: .color),
        Background(color: UIColor(hexString: "#FEE57F"), type: .color),
        Background(color: UIColor(hexString: "#FDD83F"), type: .color),
        Background(color: UIColor(hexString: "#F9C432"), type: .color),
        Background(color: UIColor(hexString: "#F6AB32"), type: .color),
        Background(color: UIColor(hexString: "#DE412C"), type: .color),
        Background(color: UIColor(hexString: "#D53E29"), type: .color),
        Background(color: UIColor(hexString: "#AE58FD"), type: .color),
        Background(color: UIColor(hexString: "#D95FF9"), type: .color),
        Background(color: UIColor(hexString: "#E262FE"), type: .color),
        Background(color: UIColor(hexString: "#EA80FC"), type: .color),
        Background(color: UIColor(hexString: "#E2ADFE"), type: .color),
        Background(color: UIColor(hexString: "#B8BBFD"), type: .color),
        Background(color: UIColor(hexString: "#8C9FFC"), type: .color),
        Background(color: UIColor(hexString: "#536CFB"), type: .color),
        Background(color: UIColor(hexString: "#3E59FB"), type: .color),
        Background(color: UIColor(hexString: "#314EFB"), type: .color),
        Background(color: UIColor(hexString: "#2891EA"), type: .color),
        Background(color: UIColor(hexString: "#3DB0FB"), type: .color),
        Background(color: UIColor(hexString: "#7FD7FC"), type: .color),
        Background(color: UIColor(hexString: "#ADE3FD"), type: .color),
        Background(color: UIColor(hexString: "#CBFBF3"), type: .color),
        Background(color: UIColor(hexString: "#A5F9EB"), type: .color),
        Background(color: UIColor(hexString: "#6FF6DD"), type: .color),
        Background(color: UIColor(hexString: "#F7C9C9"), type: .color),
        Background(color: UIColor(hexString: "#F1897F"), type: .color),
        Background(color: UIColor(hexString: "#ED4D50"), type: .color),
        Background(color: UIColor(hexString: "#ED4742"), type: .color),

        Background(type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#009FFF"), UIColor(hexString: "#ec2F4B")])),
        Background(type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#eaafc8"), UIColor(hexString: "#654ea3")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#FF416C"), UIColor(hexString: "#FF4B2B")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#8A2387"), UIColor(hexString: "#E94057"), UIColor(hexString: "#F27121")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#a8ff78"), UIColor(hexString: "#78ffd6")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#ED213A"), UIColor(hexString: "#93291E")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#FDC830"), UIColor(hexString: "#F37335")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#00B4DB"), UIColor(hexString: "#0083B0")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#a17fe0"), UIColor(hexString: "#5D26C1")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#FFFDE4"), UIColor(hexString: "#005AA7")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#DA4453"), UIColor(hexString: "#89216B")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#ad5389"), UIColor(hexString: "#3c1053")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#a8c0ff"), UIColor(hexString: "#3f2b96")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#4e54c8"), UIColor(hexString: "#8f94fb")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#bc4e9c"), UIColor(hexString: "#f80759")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#11998e"), UIColor(hexString: "#38ef7d")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#FC5C7D"), UIColor(hexString: "#6A82FB")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#FC466B"), UIColor(hexString: "#3F5EFB")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#00b09b"), UIColor(hexString: "#96c93d")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#00F260"), UIColor(hexString: "#0575E6")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#74ebd5"), UIColor(hexString: "#ACB6E5")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#667db6"), UIColor(hexString: "#0082c8"), UIColor(hexString: "#0082c8"), UIColor(hexString: "#667db6")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#e1eec3"), UIColor(hexString: "#f05053")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#ff9966"), UIColor(hexString: "#ff5e62")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#d9a7c7"), UIColor(hexString: "#fffcdc")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#0cebeb"), UIColor(hexString: "#20e3b2"), UIColor(hexString: "#29ffc6")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#06beb6"), UIColor(hexString: "#48b1bf")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#642B73"), UIColor(hexString: "#C6426E")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#1c92d2"), UIColor(hexString: "#f2fcfe")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#36D1DC"), UIColor(hexString: "#5B86E5")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#159957"), UIColor(hexString: "#155799")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#1CB5E0"), UIColor(hexString: "#000046")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#007991"), UIColor(hexString: "#78ffd6")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#56CCF2"), UIColor(hexString: "#2F80ED")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#EB5757"), UIColor(hexString: "#000000")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#4AC29A"), UIColor(hexString: "#BDFFF3")])),
        Background(isFree: false, type: .gradient, gradientLayerView: GradientLayerView(colors: [UIColor(hexString: "#B2FEFA"), UIColor(hexString: "#0ED2F7")]))
    ]

    private var scrollViewBottomConstraint: NSLayoutConstraint!

    weak var delegate: BackgroundSelectionViewControllerDelegate?

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

        scrollView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(sectionSelectionView)
        contentStackView.addArrangedSubview(backgroundSelectionView)

        titleLabel.text = "Background"

        // add swipe down gesture
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGestureRecognized))
        swipeDownGesture.direction = .down
        scrollView.addGestureRecognizer(swipeDownGesture)

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
        scrollView.heightAnchor.constraint(equalToConstant: 260).isActive = true

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

        contentStackView.anchor(top: titleSeparatorLineView.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                bottom: scrollView.bottomAnchor,
                                padding: .init(topPadding: 16))

        backgroundSelectionView.translatesAutoresizingMaskIntoConstraints = false
        backgroundSelectionView.heightAnchor.constraint(equalToConstant: 72).isActive = true

        sectionSelectionView.translatesAutoresizingMaskIntoConstraints = false
        sectionSelectionView.heightAnchor.constraint(equalToConstant: 32).isActive = true

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

    private func animateScrollView(withCompletion completion: ((_ success: Bool) -> ())?) {
        view.layoutIfNeeded()
        if self.scrollViewBottomConstraint.constant > 0 { // should show
            self.scrollViewBottomConstraint.constant = 0
        } else { // should hide
            self.scrollViewBottomConstraint.constant = scrollView.frame.height
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }
        }

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    @objc func closeButtonTapped() {
        animateScrollView(withCompletion: nil)
    }

    @objc func swipeDownGestureRecognized(_ gestureRecognizer: UISwipeGestureRecognizer) {
        animateScrollView(withCompletion: nil)
    }
}

extension BackgroundSelectionViewController: BackgroundSelectionViewDelegate {
    func didSelectBackground(background: Background, onView view: BackgroundSelectionView) {
        self.delegate?.didSelectBackground(background: background, onViewController: self)
    }
}

extension BackgroundSelectionViewController: SectionSelectionViewDelegate {
    func didSelectSection(atIndex index: Int, onView view: SectionSelectionView) {
        backgroundSelectionView.backgrounds = self.backgrounds.filter({ $0.type == sectionSelectionView.selectedBackgroundType })
        backgroundSelectionView.collectionView.setContentOffset(.zero, animated: true)
    }
}

