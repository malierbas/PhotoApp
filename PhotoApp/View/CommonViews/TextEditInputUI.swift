//
//  TextEditInputUI.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol TextEditInputUIDelegate: class {
    @objc optional func saveButtonTapped(onInputView inputView: TextEditInputUI)
    @objc optional func shouldDismiss(_ inputView: TextEditInputUI)
    @objc optional func hasChangedFont(to font: UIFont, on inputView: TextEditInputUI)
    @objc optional func hasChangedTextColor(to color: UIColor, on inputView: TextEditInputUI)
    @objc optional func hasChangedTextBackgroundColor(to color: UIColor, on inputView: TextEditInputUI)
    @objc optional func hasChangedTextCharacterSpacing(to spacing: Int, on inputView: TextEditInputUI)
    @objc optional func hasChangedTextLineSpacing(to spacing: Int, on inputView: TextEditInputUI)
    @objc optional func hasChangedTextFontSize(to size: Int, on inputView: TextEditInputUI)
    @objc optional func hasChangedTextOpacity(to opacity: CGFloat, on inputView: TextEditInputUI)
}

class TextEditInputUI: UIView {

    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        view.layer.cornerRadius = 1.5
        return view
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textAlignment = .right
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = .center
        return stackView
    }()

    var sectionButtons: [UIButton] = []

    private lazy var fontsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: fontsCollectionViewFlowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    private lazy var colorsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: colorsCollectionViewFlowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alpha = 0
        return collectionView
    }()

    private let fontsCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(topPadding: 0, leftPadding: 20, bottomPadding: 0, rightPadding: 20)
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.estimatedItemSize = CGSize(width: 60, height: 32)
        return flowLayout
    }()

    private let colorsCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(topPadding: 0, leftPadding: 20, bottomPadding: 0, rightPadding: 20)
        return flowLayout
    }()

    private lazy var textPropertyValueSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .black
        slider.maximumTrackTintColor = .gray
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.alpha = 0
        slider.isContinuous = true
        return slider
    }()

    private let sliderValuePreviewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = label.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        label.insertSubview(blurEffectView, at: 0)
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.alpha = 0
        label.textColor = .black
        return label
    }()

    var colors: [UIColor] = [
        UIColor.clear,
        UIColor(hexString: "#424242"),
        UIColor(hexString: "#9E9E9E"),
        UIColor(hexString: "#DBDBDB"),
        UIColor.white,
        UIColor(hexString: "#FEE57F"),
        UIColor(hexString: "#FDD83F"),
        UIColor(hexString: "#F9C432"),
        UIColor(hexString: "#F6AB32"),
        UIColor(hexString: "#DE412C"),
        UIColor(hexString: "#ED462F"),
        UIColor(hexString: "#F06C30"),
        UIColor(hexString: "#F39E80"),
        UIColor(hexString: "#FADDD0"),
        UIColor(hexString: "#C3F325"),
        UIColor(hexString: "#ECF641"),
        UIColor(hexString: "#F3F881"),
        UIColor(hexString: "#F8FAA6"),
        UIColor(hexString: "#FEE57F"),
        UIColor(hexString: "#FDD83F"),
        UIColor(hexString: "#F9C432"),
        UIColor(hexString: "#F6AB32"),
        UIColor(hexString: "#DE412C"),
        UIColor(hexString: "#D53E29"),
        UIColor(hexString: "#AE58FD"),
        UIColor(hexString: "#D95FF9"),
        UIColor(hexString: "#E262FE"),
        UIColor(hexString: "#EA80FC"),
        UIColor(hexString: "#E2ADFE"),
        UIColor(hexString: "#B8BBFD"),
        UIColor(hexString: "#8C9FFC"),
        UIColor(hexString: "#536CFB"),
        UIColor(hexString: "#3E59FB"),
        UIColor(hexString: "#314EFB"),
        UIColor(hexString: "#2891EA"),
        UIColor(hexString: "#3DB0FB"),
        UIColor(hexString: "#7FD7FC"),
        UIColor(hexString: "#ADE3FD"),
        UIColor(hexString: "#CBFBF3"),
        UIColor(hexString: "#A5F9EB"),
        UIColor(hexString: "#6FF6DD"),
        UIColor(hexString: "#F7C9C9"),
        UIColor(hexString: "#F1897F"),
        UIColor(hexString: "#ED4D50"),
        UIColor(hexString: "#ED4742")
    ]

    var fonts: [UIFont?] = [
        UIFont(name: "Tangerine-Bold", size: 24),
        UIFont(name: "DancingScript-Bold", size: 20),
        UIFont(name: "Baskerville", size: 20),
        UIFont(name: "AmaticSC-Regular", size: 20),
        UIFont(name: "Raleway-Regular", size: 20),
        UIFont(name: "Quicksand", size: 20),
        UIFont(name: "Montserrat-Regular", size: 20),
        UIFont(name: "Monoton-Regular", size: 20),
        UIFont(name: "Rustico-Regular", size: 20),
        UIFont(name: "Amiri-Regular", size: 20),
        UIFont(name: "BadScript-Regular", size: 20),
        UIFont(name: "IndieFlower", size: 20),
        UIFont(name: "NanumBrush", size: 20),
        UIFont(name: "GiveYouGlory", size: 20),
        UIFont(name: "HomemadeApple-Regular", size: 20),
        UIFont(name: "Codystar", size: 20),
        UIFont(name: "FrederickatheGreat-Regular", size: 20),
        UIFont(name: "PTSans-Regular", size: 20),
        UIFont(name: "PlayfairDisplay-Regular", size: 20),
        UIFont(name: "SebastianSignature", size: 20),
        UIFont(name: "NixieOne-Regular", size: 20),
        UIFont(name: "CutiveMono-Regular", size: 20),
        UIFont(name: "Courier", size: 20),
        UIFont(name: "Caveat-Regular", size: 20),
        UIFont(name: "Bevan-Regular", size: 20)
    ]

    var activeEditingSection: EditingSection = .font

    enum EditingSection: Int, CaseIterable {
        case font = 0
        case textFontSize
        case textColor
        case textBackgroundColor
        case textCharacterSpacing
//        case textLineSpacing
        case textOpacity

        var iconImage: UIImage? {
            switch self {
            case .font:
                return UIImage(named: "fontIcon")
            case .textColor:
                return UIImage(named: "textColorIcon")
            case .textBackgroundColor:
                return UIImage(named: "textBackgroundColorIcon")
            case .textCharacterSpacing:
                return UIImage(named: "characterSpacingIcon")
            case .textFontSize:
                return UIImage(named: "textFontSize")
//            case .textLineSpacing:
//                return UIImage(named: "lineSpacingIcon")
            case .textOpacity:
                return UIImage(named: "opacityIcon")
            }
        }
    }

    weak var delegate: TextEditInputUIDelegate?

    var template: Template?

    init() {
        super.init(frame: .zero)
        prepareUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sliderValuePreviewLabel.layer.cornerRadius = sliderValuePreviewLabel.frame.height / 2
    }

    private func prepareUI() {
        func printAllFontNames() {
            for familyname in UIFont.familyNames {
                for fname in UIFont.fontNames(forFamilyName: familyname) {
                    print("---", fname, "familyName: ", familyname)
                }
            }
        }

        printAllFontNames()
        backgroundColor = .white
        addSubview(topLineView)
        addSubview(saveButton)
        addSubview(buttonsStackView)
        addSubview(fontsCollectionView)
        addSubview(colorsCollectionView)
        addSubview(textPropertyValueSlider)
        addSubview(sliderValuePreviewLabel)

        colorsCollectionView.register(ColorCollectionViewCell.self)
        fontsCollectionView.register(FontCollectionViewCell.self)

        // add swipe down gesture
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGestureRecognized))
        swipeDownGesture.direction = .down
        addGestureRecognizer(swipeDownGesture)

        var buttons: [UIButton] = []
        for editingSection in EditingSection.allCases {
            let button = UIButton(type: .system)
            button.setImage(editingSection.iconImage?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(handleEditingSectionButtonTap), for: .touchUpInside)
            button.tintColor = .black
            button.tag = editingSection.rawValue
            button.alpha = (editingSection == .font ? 1 : 0.3)
            buttons.append(button)
        }

        sectionButtons = buttons

        sectionButtons.forEach({ buttonsStackView.addArrangedSubview($0) })

        setupLayout()

    }

    private func setupLayout() {

        topLineView.anchor(top: topAnchor, padding: .init(topPadding: 14))
        topLineView.anchorCenterXToSuperview()
        topLineView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: 3).isActive = true

        saveButton.anchor(top: topAnchor,
                          trailing: trailingAnchor,
                          padding: .init(topPadding: 4, rightPadding: 12))

        buttonsStackView.anchor(leading: leadingAnchor,
                                trailing: trailingAnchor,
                                bottom: bottomAnchor,
                                padding: .init(leftPadding: 16, bottomPadding: 16, rightPadding: 16))

        buttonsStackView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        fontsCollectionView.anchor(leading: leadingAnchor,
                                   trailing: trailingAnchor,
                                   bottom: buttonsStackView.topAnchor,
                                   padding: .init(bottomPadding: 16))
        fontsCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        colorsCollectionView.anchor(leading: leadingAnchor,
                                   trailing: trailingAnchor,
                                   bottom: buttonsStackView.topAnchor,
                                   padding: .init(bottomPadding: 16))
        colorsCollectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        textPropertyValueSlider.anchor(bottom: buttonsStackView.topAnchor,
                                       padding: .init(leftPadding: 32, bottomPadding: 16, rightPadding: 32))
        textPropertyValueSlider.anchorCenterXToSuperview()
        textPropertyValueSlider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        textPropertyValueSlider.heightAnchor.constraint(equalToConstant: 40).isActive = true

        sliderValuePreviewLabel.anchor(bottom: topAnchor, padding: .init(bottomPadding: 8))
        sliderValuePreviewLabel.anchorCenterXToSuperview()
        sliderValuePreviewLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sliderValuePreviewLabel.widthAnchor.constraint(equalTo: sliderValuePreviewLabel.heightAnchor, multiplier: 1).isActive = true

    }

    @objc func sliderValueChanged() {
        let userFriendlyValue = Int((textPropertyValueSlider.value - 0.5) / 0.1)

        switch activeEditingSection {
//        case .textCharacterSpacing, .textLineSpacing:
        case .textCharacterSpacing:
            sliderValuePreviewLabel.text = "\(userFriendlyValue)"
        case .textOpacity:
            sliderValuePreviewLabel.text = String(format: "%.1f", textPropertyValueSlider.value)
        case .textFontSize:
            sliderValuePreviewLabel.text = String(Int(textPropertyValueSlider.value))

        default:
            break
        }

        if self.sliderValuePreviewLabel.alpha == 0 && self.sliderValuePreviewLabel.alpha != 1 { // show with animation
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.sliderValuePreviewLabel.alpha = 1
            }, completion: nil)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let self = self else { return }
            if !self.textPropertyValueSlider.isTracking { // dismiss with animation
                UIView.animate(withDuration: 0.8, delay: 0.2, options: .curveEaseInOut, animations: { [weak self] in
                    guard let self = self else { return }
                    self.sliderValuePreviewLabel.alpha = 0
                    }, completion: nil)
            }
        })

        let userFriendlySliderValue = Int((textPropertyValueSlider.value - 0.5) / 0.1)
        switch activeEditingSection {
        case .textCharacterSpacing:
            self.delegate?.hasChangedTextCharacterSpacing?(to: userFriendlySliderValue, on: self)
        case .textFontSize:
            self.delegate?.hasChangedTextFontSize?(to: Int(textPropertyValueSlider.value), on: self)
//        case .textLineSpacing:
//            self.delegate?.hasChangedTextLineSpacing?(to: userFriendlySliderValue, on: self)
        case .textOpacity:
            self.delegate?.hasChangedTextOpacity?(to: CGFloat(textPropertyValueSlider.value), on: self)
        default:
            break
        }
    }

    @objc func saveButtonTapped() {
        self.delegate?.saveButtonTapped?(onInputView: self)
    }


    @objc func handleEditingSectionButtonTap(_ sender: UIButton) {
        UIImpactFeedbackGenerator().impactOccurred()


        guard let activeEditingSection = EditingSection(rawValue: sender.tag) else { return }

        colorsCollectionView.alpha = 0
        textPropertyValueSlider.alpha = 0
        fontsCollectionView.alpha = 0
        sliderValuePreviewLabel.alpha = 0

        sectionButtons.forEach({ button in
            button.alpha = 0.3
        })
        sectionButtons[activeEditingSection.rawValue].alpha = 1

        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            switch activeEditingSection {
            case .font:
                self.fontsCollectionView.alpha = 1
            case .textColor, .textBackgroundColor:
                self.colorsCollectionView.alpha = 1
//            case .textLineSpacing, .textCharacterSpacing:
            case .textCharacterSpacing:
                self.textPropertyValueSlider.alpha = 1
                self.textPropertyValueSlider.setValue(0.5, animated: false)
            case .textOpacity:
                self.textPropertyValueSlider.alpha = 1
                self.textPropertyValueSlider.setValue(1, animated: false)
            case .textFontSize:
                self.textPropertyValueSlider.maximumValue = 100
                self.textPropertyValueSlider.alpha = 1
                self.textPropertyValueSlider.setValue(30, animated: false)

            }
        }, completion: nil)

        self.activeEditingSection = activeEditingSection
    }

    @objc func swipeDownGestureRecognized(_ gestureRecognizer: UISwipeGestureRecognizer) {
        self.delegate?.shouldDismiss?(self)
    }

}


extension TextEditInputUI: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case colorsCollectionView:
            return colors.count
        case fontsCollectionView:
            return fonts.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case colorsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
            let color = colors[indexPath.item]
            cell.color = color
            return cell
        case fontsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FontCollectionViewCell.reuseIdentifier, for: indexPath) as? FontCollectionViewCell else { return UICollectionViewCell() }
            cell.font = fonts[indexPath.item]
            return cell
        default:
            return UICollectionViewCell()
        }
    }

}

extension TextEditInputUI: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case colorsCollectionView:
            let color = colors[indexPath.item]
            if activeEditingSection == .textColor {
                self.delegate?.hasChangedTextColor?(to: color, on: self)
            } else if activeEditingSection == .textBackgroundColor {
                self.delegate?.hasChangedTextBackgroundColor?(to: color, on: self)
            }
        case fontsCollectionView:
            guard let font = fonts[indexPath.item] else { return }
            self.delegate?.hasChangedFont?(to: font, on: self)
        default:
            return
        }

        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UISelectionFeedbackGenerator().selectionChanged()
    }
}

extension TextEditInputUI: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case colorsCollectionView:
            let verticalPaddingsTotal = colorsCollectionViewFlowLayout.sectionInset.top + colorsCollectionViewFlowLayout.sectionInset.bottom
            let height = collectionView.frame.height - verticalPaddingsTotal
            return CGSize(width: height, height: height)
        case fontsCollectionView:
            return fontsCollectionViewFlowLayout.estimatedItemSize
        default:
            return .zero
        }
    }
}
