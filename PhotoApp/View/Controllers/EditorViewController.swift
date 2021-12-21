//
//  EditorViewController.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//


import UIKit

class EditorViewController: UIViewController, UINavigationControllerDelegate {
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 75))
        btn.backgroundColor = .clear
        btn.setImage(UIImage(named: "backButtonWhite"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Editor"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var canvasView: CanvasView = {
        let view = CanvasView(template: self.template)
        view.backgroundColor = .white
        view.layer.shadowOpacity = 1.0
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.delegate = self
        return view
    }()
    
    private lazy var bottomControlView: BottomControlView = {
        let bottomControlView = BottomControlView()
        bottomControlView.delegate = self
        return bottomControlView
    }()

    private lazy var onlyAvailableWithPremiumView: OnlyAvailableWithPremiumView = {
        let onlyAvailableWithPremiumView = OnlyAvailableWithPremiumView()
        onlyAvailableWithPremiumView.isHidden = true
        onlyAvailableWithPremiumView.delegate = self
        return onlyAvailableWithPremiumView
    }()

    private let darkOverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.alpha = 0
        return view
    }()

    private lazy var textEditInputUI: TextEditInputUI = {
        let textEditInputUI = TextEditInputUI()
        textEditInputUI.delegate = self
        textEditInputUI.template = self.template
        return textEditInputUI
    }()

    override var inputAccessoryView: UIView? {
        return textEditInputUI
    }

    override var canBecomeFirstResponder: Bool {
        if isFirstResponder {
            return true
        }
        return false
    }

    var template: Template?

    private var canvasWidthConstraint: NSLayoutConstraint!
    private let bottomControlHeight: CGFloat = 60

    private var imagePickerViewForImageSelection: EditableImageView?

    var userHasPickedImage: Bool = false {
        didSet {
            if userHasPickedImage {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backButtonTapped))
                navigationItem.leftBarButtonItem?.tintColor = .white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    private func prepareUI() {
//        AnalyticsManager.shared.log(event: .editorSceneOpened)
        view.backgroundColor = UIColor(hexString: "#1C1F21")
        title = "Editor"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(topView)
        topView.addSubview(backButton)
        topView.addSubview(topLabel)
        view.addSubview(canvasView)
        view.addSubview(bottomControlView)
        view.addSubview(onlyAvailableWithPremiumView)
        view.addSubview(darkOverView)

        if let isFree = template?.isFree, !isFree && !LocalStorageManager.shared.isPremiumUser {
            onlyAvailableWithPremiumView.isHidden = false
        }

        bottomControlView.backgroundSelectionButton.isHidden = !(template?.canBeAssignedFullBackground ?? false)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        setupLayout()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.init(rawValue: LocalStorageManager.Keys.isPremiumUser.rawValue), object: nil, queue: nil) { [weak self] (_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let isFree = self.template?.isFree, !isFree && !LocalStorageManager.shared.isPremiumUser {
                    self.onlyAvailableWithPremiumView.isHidden = false
                } else {
                    self.onlyAvailableWithPremiumView.isHidden = true
                }
            }
        }
        
        //: empty canvas view
        switch GlobalConstants.canvasType
        {
            case 916:
                canvasView.backgroundColor = .clear
                canvasView.backgroundImageView.alpha = 0
            case 45:
                canvasView.backgroundColor = .clear
                canvasView.backgroundImageView.alpha = 0
            case 11:
                canvasView.backgroundColor = .clear
                canvasView.backgroundImageView.alpha = 0
            default:
                canvasView.backgroundColor = .clear
                canvasView.backgroundImageView.alpha = 0
        }
        
        //: backButton
        self.backButton.expandValidTouchArea(inset: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }

    private func setupLayout() {
        topView.setHeight(size: 100)
        topView.equalsToLeadings()
        topView.pinToTopWithSize(with: 10)
        topView.equalsToTrailings()
         
        backButton.equalsToLeadings(with: 25)
        backButton.centerYToSuperView(with: 8)
         
        topLabel.centerXToSuperView(with: 0)
        topLabel.pinToTopWithSize(with: 50)
        
        canvasView.anchorCenterXToSuperview()
        canvasView.anchorCenterYToSuperview(constant: -(bottomControlHeight + view.safeAreaInsets.bottom)/2)
        canvasWidthConstraint = canvasView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        canvasWidthConstraint.priority = .defaultLow
        canvasWidthConstraint.isActive = true
        canvasView.heightAnchor.constraint(equalTo: canvasView.widthAnchor, multiplier: 1 / canvasRatio).isActive = true
        canvasView.bottomAnchor.constraint(lessThanOrEqualTo: bottomControlView.topAnchor, constant: -16).isActive = true
        canvasView.topAnchor.constraint(greaterThanOrEqualTo: topView.bottomAnchor, constant: 0).isActive = true

        bottomControlView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        bottomControlView.heightAnchor.constraint(equalToConstant: bottomControlHeight).isActive = true

        onlyAvailableWithPremiumView.anchor(leading: view.leadingAnchor,
                                            trailing: view.trailingAnchor,
                                            bottom: bottomControlView.topAnchor,
                                            padding: .init(leftPadding: 16, bottomPadding: 12, rightPadding: 16))
        onlyAvailableWithPremiumView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        darkOverView.fillSuperview()

        textEditInputUI.translatesAutoresizingMaskIntoConstraints = false
        textEditInputUI.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        textEditInputUI.heightAnchor.constraint(equalToConstant: 124).isActive = true
    }
    
    @objc func presentPicker(withCompletion completion: (() -> Void)? = nil) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.presentInFullScreen(imagePicker, animated: true, completion: completion)
    }

    @objc func backButtonTapped() {
        guard !userHasPickedImage else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            let customAlertViewController = CustomAlertViewController(titleText: "Discard changes!", descriptionText: "Do you want to keep editing? Otherwise you will lose any of your customizations.", callToActionButtonTitle: "Continue", cancelButtonTitle: "Remove")
            customAlertViewController.modalTransitionStyle = .crossDissolve
            customAlertViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlertViewController.callToActionButtonAction = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }

            customAlertViewController.cancelButtonAction = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            present(customAlertViewController, animated: true, completion: nil)
            return
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    func prepareForSaving(withCompletionBlock completionBlock: (() -> Void)? = nil) {
        canvasView.clearAllEditModes()

//        let scaleRatio = self.hiddenCanvasViewForImageExport.frame.width / self.canvasView.frame.width

        completionBlock?()
    }
    
    func endSaving() {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        guard let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) else { return }
        let touchLocation = touch.location(in: activeTextField.inputAccessoryView)
        let userBufferInPointsToMistakenlyTapAboveScrollView: CGFloat = 20
        if (touchLocation.y < -userBufferInPointsToMistakenlyTapAboveScrollView) { // empty space area tapped.
            resignActiveTextField()
        }
    }

    private func resignActiveTextField() {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {
            activeTextField.isSelected = false
            activeTextField.resignFirstResponder()
        }
    }

    deinit {
        print("deiniting editor scene")
    }
}

extension EditorViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("error retrieving image.")
            return
        }
        self.userHasPickedImage = true
//        AnalyticsManager.shared.log(event: .imageAddedToTemplate)
        if let indexOfPickedImage = canvasView.imageViews.firstIndex(where: { $0 === imagePickerViewForImageSelection }) {
            template?.canvasImages?[indexOfPickedImage].userPickedImage = image
            template?.canvasImages?[indexOfPickedImage].scrollContentOffset = .zero
            template?.canvasImages?[indexOfPickedImage].scrollZoomScale = 0
            (canvasView.imageViews[indexOfPickedImage] as! EditableImageView).canvasImage = template?.canvasImages?[indexOfPickedImage]
            (canvasView.imageViews[indexOfPickedImage] as! EditableImageView).shouldTryToFitImage = true
            (canvasView.imageViews[indexOfPickedImage] as! EditableImageView).layoutSubviews()
        }
        dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
}

extension EditorViewController: BottomControlViewDelegate {
    func didTapShareButton(onView view: BottomControlView) {
//        AnalyticsManager.shared.log(event: .exportButtonTapped)
        let shareViewController = ShareViewController()
        shareViewController.modalTransitionStyle = .crossDissolve
        shareViewController.modalPresentationStyle = .overFullScreen
        shareViewController.delegate = self
        present(shareViewController, animated: true, completion: nil)
    }

    func didTapPreviewButton(onView view: BottomControlView) {
        prepareForSaving { [weak self] in
            guard let self = self else { return }
            let previewViewController = PreviewViewController(image: self.canvasView.asImage2())
            self.presentInFullScreen(previewViewController, animated: true, completion: { [weak self] in
                guard let self = self else { return }
                self.endSaving()
            })
        }
    }

    func didTapColorPickerButton(onView view: BottomControlView) {
        let backgroundSelectionViewController = BackgroundSelectionViewController()
        backgroundSelectionViewController.modalTransitionStyle = .crossDissolve
        backgroundSelectionViewController.modalPresentationStyle = .overFullScreen
        backgroundSelectionViewController.delegate = self
        present(backgroundSelectionViewController, animated: true, completion: nil)
    }

    func didTapStickerPickerButton(onView view: BottomControlView) {
        let stickerPickerViewController = StickerSelectionViewController()
        stickerPickerViewController.modalTransitionStyle = .crossDissolve
        stickerPickerViewController.modalPresentationStyle = .overFullScreen
        stickerPickerViewController.delegate = self
        present(stickerPickerViewController, animated: true, completion: nil)

    }

    func didTapAddTextButton(onView view: BottomControlView) {
        let canvasText = Template.CanvasText(frame1080x1920: .zero, text: "", font: UIFont.systemFont(ofSize: 18, weight: .regular))
        let editableTextField = EditableTextField()
        editableTextField.model = canvasText
        template?.canvasTexts?.append(canvasText)
        canvasView.textFields.append(editableTextField)
        let textFieldWidth = canvasView.frame.width * 0.8
        editableTextField.frame = CGRect(x: (canvasView.frame.width - textFieldWidth) / 2.0, y: canvasView.center.y, width: textFieldWidth, height: 50)
        editableTextField.delegate = canvasView
        canvasView.addSubview(editableTextField)
        editableTextField.isSelected = true
        editableTextField.becomeFirstResponder()
    }
}

extension EditorViewController: ShareViewControllerDelegate {
    func willStartSaving(withCompletionBlock completionBlock: ((_ image: UIImage) -> Void)? = nil) {
        switch GlobalConstants.canvasType
        {
            case 916, 45, 11:
                prepareForSaving { [weak self] in
                    guard let self = self else { return }
                    completionBlock?(self.canvasView.imageViews[0].asImage2())
                }
            default:
                prepareForSaving { [weak self] in
                    guard let self = self else { return }
                    completionBlock?(self.canvasView.asImage2())
            }
        }
    }
    
    func didFinishSaving() {
        endSaving()
    }
}

extension EditorViewController: CanvasViewDelegate {
    func didTap(imagePickerView: EditableImageView, onView view: CanvasView) {
        UIImpactFeedbackGenerator().impactOccurred()
        guard let isFree = template?.isFree, isFree || LocalStorageManager.shared.isPremiumUser else {
            onlyAvailableWithPremiumView.shake(duration: 0.6)
            return
        }
        if !imagePickerView.isSelected && imagePickerView.imageView.image != nil {
            // clear all selections first
            canvasView.clearAllEditModes()
            // assign new selection
            imagePickerView.isSelected = true
        } else { // it is already selected. so move to image picking
            self.imagePickerViewForImageSelection = imagePickerView
            presentPicker {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.canvasView.clearAllEditModes()
                }
            }
        }
    }

    func didTapEditButton(onEditableImageView editableImageView: EditableImageView, onCanvasView canvasView: CanvasView) {
        self.imagePickerViewForImageSelection = editableImageView
        presentPicker {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.canvasView.clearAllEditModes()
            }
        }
    }

    func didTapRemoveButton(onEditableImageView editableImageView: EditableImageView, onCanvasView canvasView: CanvasView) {
        editableImageView.isSelected = false
        editableImageView.imageView.image = nil
        editableImageView.imageView.layer.borderWidth = 0.5
    }

    func didTapEditModeView(onEditableImageView editableImageView: EditableImageView, onCanvasView canvasView: CanvasView) {
        editableImageView.isSelected.toggle()
    }

    func didTapRemoveButton(onStickerView stickerView: StickerView, onCanvasView canvasView: CanvasView) {
        if let indexOfSticker = template?.stickers.firstIndex(where: { $0.image == stickerView.sticker?.image }) {
            template?.stickers.remove(at: indexOfSticker)
            canvasView.stickerViews.remove(at: indexOfSticker)
            stickerView.removeFromSuperview()
        }
    }
}


extension EditorViewController: OnlyAvailableWithPremiumViewDelegate {
    func tryForFreeButtonTapped(onView view: OnlyAvailableWithPremiumView) {
        UIImpactFeedbackGenerator().impactOccurred()
        presentInFullScreen(SubscriptionViewController(), animated: true, completion: nil)
    }

    func bottomRemoveButtonTapped(onView view: OnlyAvailableWithPremiumView) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditorViewController: BackgroundSelectionViewControllerDelegate {
    func didSelectBackground(background: Background, onViewController viewController: BackgroundSelectionViewController) {
        //AnalyticsManager.shared.log(event: .templateBackgroundSelected)
        guard let freeTemplate = template?.isFree, (freeTemplate && background.isFree) || LocalStorageManager.shared.isPremiumUser else {
            dismiss(animated: false, completion: { [weak self] in
                guard let self = self else { return }
                self.presentInFullScreen(SubscriptionViewController(), animated: true, completion: nil)
            })
            return
        }

        template?.background = background
        canvasView.refreshBackground()
    }
}

extension EditorViewController: StickerSelectionViewControllerDelegate {
    func didSelectStickerImage(sticker: Sticker, onViewController viewController: StickerSelectionViewController) {
        UIImpactFeedbackGenerator().impactOccurred()

        guard let freeTemplate = template?.isFree, (freeTemplate && sticker.isFree) || LocalStorageManager.shared.isPremiumUser else {
            dismiss(animated: false, completion: { [weak self] in
                guard let self = self else { return }
                self.presentInFullScreen(SubscriptionViewController(), animated: true, completion: nil)
            })
            return
        }

        sticker.latestCenter = canvasView.center
        template?.stickers.append(sticker)
        let stickerView = StickerView(sticker: sticker)
        stickerView.center = sticker.latestCenter
        stickerView.frame.size = CGSize(width: 100, height: 100)
        stickerView.delegate = canvasView
        canvasView.stickerViews.append(stickerView)
        canvasView.addSubview(stickerView)
    }
}

extension EditorViewController: TextEditInputUIDelegate {
    func saveButtonTapped(onInputView inputView: TextEditInputUI) {
        resignActiveTextField()
    }

    func shouldDismiss(_ inputView: TextEditInputUI) {
        resignActiveTextField()
    }

    func hasChangedFont(to font: UIFont, on inputView: TextEditInputUI) {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {
            activeTextField.font = font

            if let indexOfActiveTextField = canvasView.textFields.firstIndex(of: activeTextField) {
                template?.canvasTexts?[indexOfActiveTextField].font = font
            }
        }
    }

    func hasChangedTextColor(to color: UIColor, on inputView: TextEditInputUI) {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {
            activeTextField.textColor = color
            if let indexOfActiveTextField = canvasView.textFields.firstIndex(of: activeTextField) {
                template?.canvasTexts?[indexOfActiveTextField].textColor = color
            }
        }
    }

    func hasChangedTextBackgroundColor(to color: UIColor, on inputView: TextEditInputUI) {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {
            activeTextField.backgroundColor = color
            if let indexOfActiveTextField = canvasView.textFields.firstIndex(of: activeTextField) {
                template?.canvasTexts?[indexOfActiveTextField].textBackgroundColor = color
            }
        }
    }

    func hasChangedTextLineSpacing(to spacing: Int, on inputView: TextEditInputUI) {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = CGFloat(spacing)
            activeTextField.defaultTextAttributes.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)

            if let indexOfActiveTextField = canvasView.textFields.firstIndex(of: activeTextField) {
                template?.canvasTexts?[indexOfActiveTextField].lineSpacing = CGFloat(spacing)
            }
        }
    }

    func hasChangedTextCharacterSpacing(to spacing: Int, on inputView: TextEditInputUI) {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {
            activeTextField.defaultTextAttributes.updateValue(CGFloat(spacing) * 3.0, forKey: NSAttributedString.Key.kern)

            if let indexOfActiveTextField = canvasView.textFields.firstIndex(of: activeTextField) {
                template?.canvasTexts?[indexOfActiveTextField].characterSpacing = CGFloat(spacing)
            }
        }
    }

    func hasChangedTextOpacity(to opacity: CGFloat, on inputView: TextEditInputUI) {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {
            activeTextField.alpha = opacity

            if let indexOfActiveTextField = canvasView.textFields.firstIndex(of: activeTextField) {
                template?.canvasTexts?[indexOfActiveTextField].textAlpha = opacity
            }
        }
    }

    func hasChangedTextFontSize(to size: Int, on inputView: TextEditInputUI) {
        if let activeTextField = canvasView.textFields.first(where: { $0.isFirstResponder }) {

            activeTextField.font = activeTextField.font?.withSize(CGFloat(size))

            if let indexOfActiveTextField = canvasView.textFields.firstIndex(of: activeTextField) {
                template?.canvasTexts?[indexOfActiveTextField].font = activeTextField.font
            }
        }
    }
}
