//
//  EditPhotoViewController.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit

open class EditPhotoViewController: UIViewController {
    //MARK: - Properties
    //: Views
    private var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "homeViewBackground")
        return imageView
    }()

    private var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 31))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "backBlackArrow"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backButtonAction(_:)), for: .touchUpInside)
        return button
    }()

    private var topLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var selectedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tag = 2
        return imageView
    }()

    private var hiddenEditView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var removeEditViewButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "xButton"), for: .normal)
        button.addTarget(self, action: #selector(removeEditViewAction(_:)), for: .touchUpInside)
        button.tag = 2
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var editImageButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "editImage1"), for: .normal)
        button.addTarget(self, action: #selector(editImageTapped(_:)), for: .touchUpInside)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var addTextView: UILabel = {
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.8)
        label.text = "T"
        label.textAlignment = .center
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        } else {
            // Do something earlier versions
        }
        return label
    }()

    private var addStickerView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "stickerImage"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private var newPhotoButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "mountains"), for: .normal)
        button.addTarget(self, action: #selector(newPhotoButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //: Variables
    var isEditActive = false

    open var originalSelectedImage: UIImage! {
        didSet {
            self.selectedImage.image = originalSelectedImage
        }
    }


    static let maxDrawLineImageWidth: CGFloat = 600

    @objc public var filterColViewH: CGFloat = 80

    @objc public var ashbinNormalBgColor = zlRGB(40, 40, 40).withAlphaComponent(0.8)

    @objc public lazy var cancelBtn = UIButton(type: .custom)

    @objc public lazy var scrollView = UIScrollView()

    // 上方渐变阴影层
    @objc public lazy var topShadowView = UIView()

    @objc public lazy var topShadowLayer = CAGradientLayer()

    // 下方渐变阴影层
    @objc public var bottomShadowView = UIView()

    @objc public var bottomShadowLayer = CAGradientLayer()

    @objc public var doneBtn = UIButton(type: .custom)

    @objc public var revokeBtn = UIButton(type: .custom)

    @objc public lazy var ashbinView = UIView()

    @objc public lazy var ashbinImgView = UIImageView(image: getImage("zl_ashbin"), highlightedImage: getImage("zl_ashbin_open"))

    @objc public var drawLineWidth: CGFloat = 5

    @objc public var mosaicLineWidth: CGFloat = 25

    var animate = false

    var originalImage: UIImage

    // 第一次进入界面时，布局后frame，裁剪dimiss动画使用
    var originalFrame: CGRect = .zero

    // 图片可编辑rect
    var editRect: CGRect

    let tools: [ZLEditImageViewController.EditImageTool]

    var selectRatio: ZLImageClipRatio?

    var editImage: UIImage

    lazy var containerView = UIView()

    // Show image.
    lazy var imageView = UIImageView()

    // Show draw lines.
    lazy var drawingImageView = UIImageView()

    // Show text and image stickers.
    lazy var stickersContainer = UIView()

    // 处理好的马赛克图片
    var mosaicImage: UIImage?

    // 显示马赛克图片的layer
    var mosaicImageLayer: CALayer?

    // 显示马赛克图片的layer的mask
    var mosaicImageLayerMaskLayer: CAShapeLayer?

    var selectedTool: ZLEditImageViewController.EditImageTool?

    let drawColors: [UIColor]

    var currentDrawColor = ZLPhotoConfiguration.default().editImageDefaultDrawColor

    var drawPaths: [ZLDrawPath]

    var mosaicPaths: [ZLMosaicPath]

    // collectionview 中的添加滤镜的小图
    var thumbnailFilterImages: [UIImage] = []

    // 选择滤镜后对原图添加滤镜后的图片
    var filterImages: [String: UIImage] = [:]

    var currentFilter: ZLFilter

    var stickers: [UIView] = []

    var isScrolling = false

    var shouldLayout = true

    var imageStickerContainerIsHidden = true

    var angle: CGFloat

    var panGes: UIPanGestureRecognizer!

    var imageSize: CGSize {
        if self.angle == -90 || self.angle == -270 {
            return CGSize(width: self.originalImage.size.height, height: self.originalImage.size.width)
        }
        return self.originalImage.size
    }

    @objc public var editFinishBlock: ((UIImage, ZLEditImageModel?) -> Void)?

    @objc public var cancelEditBlock: (() -> Void)?

    @objc public var removeBackgroundBlock: ((UIImage) -> Void)?

    @objc public var removedBackGroundBlock: ((UIImage) -> Void)?

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    deinit {
        zl_debugPrint("ZLEditImageViewController deinit")
    }

    @objc public init(image: UIImage, editModel: ZLEditImageModel? = nil) {
        self.originalImage = image.fixOrientation()
        self.editImage = self.originalImage
        self.editRect = editModel?.editRect ?? CGRect(origin: .zero, size: image.size)
        self.drawColors = ZLPhotoConfiguration.default().editImageDrawColors
        self.currentFilter = editModel?.selectFilter ?? .normal
        self.drawPaths = editModel?.drawPaths ?? []
        self.mosaicPaths = editModel?.mosaicPaths ?? []
        self.angle = editModel?.angle ?? 0
        self.selectRatio = editModel?.selectRatio

        var ts = ZLPhotoConfiguration.default().editImageTools
        if ts.contains(.imageSticker), ZLPhotoConfiguration.default().imageStickerContainerView == nil {
            ts.removeAll { $0 == .imageSticker }
        }
        self.tools = ts

        super.init(nibName: nil, bundle: nil)

        if !self.drawColors.contains(self.currentDrawColor) {
            self.currentDrawColor = self.drawColors.first!
        }

        let teStic = editModel?.textStickers ?? []
        let imStic = editModel?.imageStickers ?? []

        var stickers: [UIView?] = Array(repeating: nil, count: teStic.count + imStic.count)
        teStic.forEach { (cache) in
            let v = ZLTextStickerView(from: cache.state)
            stickers[cache.index] = v
        }
        imStic.forEach { (cache) in
            let v = ZLImageStickerView(from: cache.state)
            stickers[cache.index] = v
        }

        self.stickers = stickers.compactMap { $0 }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - LifeCycle
    open override func viewDidLoad() {
        super.viewDidLoad()

        //: setup ui
        setupUI()

        //: Common
        rotationImageView()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard self.shouldLayout else {
            return
        }
        self.shouldLayout = false
        zl_debugPrint("edit image layout subviews")
        var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            insets = self.view.safeAreaInsets
        }
        insets.top = max(20, insets.top)
        
        self.scrollView.frame = self.view.bounds
        self.resetContainerViewFrame()
        
        self.topShadowView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        self.topShadowLayer.frame = self.topShadowView.bounds
        self.cancelBtn.frame = CGRect(x: 30, y: insets.top+10, width: 28, height: 28)
        
        self.bottomShadowView.frame = CGRect(x: 0, y: self.view.frame.height-140-insets.bottom, width: self.view.frame.width, height: 140+insets.bottom)
        self.bottomShadowLayer.frame = self.bottomShadowView.bounds
        
        self.revokeBtn.frame = CGRect(x: self.view.frame.width - 15 - 35, y: 30, width: 35, height: 30)
        
        let toolY: CGFloat = 85
        
        let doneBtnH = ZLLayout.bottomToolBtnH
        let doneBtnW = localLanguageTextValue(.editFinish).boundingRect(font: ZLLayout.bottomToolTitleFont, limitSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: doneBtnH)).width + 20
        self.doneBtn.frame = CGRect(x: self.view.frame.width-20-doneBtnW, y: toolY-2, width: doneBtnW, height: doneBtnH)
        
        if !self.drawPaths.isEmpty {
            self.drawLine()
        }
        if !self.mosaicPaths.isEmpty {
            self.generateNewMosaicImage()
        }
        
        if let index = self.drawColors.firstIndex(where: { $0 == self.currentDrawColor}) {
        }
    }

    //MARK: - Setups
    func setupUI() {
        DispatchQueue.main.async {
            //: main view
            self.view.backgroundColor = .white

            //: subviews & constraints
            self.view.addSubview(self.backgroundView)
            self.view.addSubview(self.backButton)
            self.view.addSubview(self.topLabel)
            self.view.addSubview(self.newPhotoButton)
            self.view.addSubview(self.imageContainerView)
            self.imageContainerView.addSubview(self.selectedImage)
            self.view.addSubview(self.bottomBar)

            if #available(iOS 9.0, *)
            {
                //: Stack View
                let stackView = UIStackView()
                stackView.spacing = 5
                stackView.axis = .horizontal
                stackView.distribution = .fillEqually
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.backgroundColor = .clear

                self.bottomBar.addSubview(stackView)
                stackView.leadingAnchor.constraint(equalTo: self.bottomBar.leadingAnchor, constant: 0).isActive = true
                stackView.trailingAnchor.constraint(equalTo: self.bottomBar.trailingAnchor, constant: 0).isActive = true
                stackView.bottomAnchor.constraint(equalTo: self.bottomBar.bottomAnchor, constant: 0).isActive = true
                stackView.topAnchor.constraint(equalTo: self.bottomBar.topAnchor, constant: 0).isActive = true
                stackView.clipsToBounds = true
                stackView.addArrangedSubview(self.addTextView)
                stackView.addArrangedSubview(self.addStickerView)
            }

            //: Edit Image
            self.imageContainerView.addSubview(self.scrollView)
            
            self.scrollView.addSubview(self.containerView)
            
            self.containerView.addSubview(self.imageView)
            
            self.containerView.addSubview(self.drawingImageView)
            
            self.containerView.addSubview(self.stickersContainer)
    
            self.containerView.addSubview(self.hiddenEditView)
            
            self.hiddenEditView.addSubview(self.removeEditViewButton)
            
            self.hiddenEditView.addSubview(self.editImageButton)

            if self.tools.contains(.imageSticker) {
                ZLPhotoConfiguration.default().imageStickerContainerView?.hideBlock = { [weak self] in
                    self?.setToolView(show: true)
                    self?.imageStickerContainerIsHidden = true
                }

                ZLPhotoConfiguration.default().imageStickerContainerView?.selectImageBlock = { [weak self] (image) in
                    self?.addImageStickerView(image)
                }
            }

            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
            tapGes.delegate = self
            self.containerView.addGestureRecognizer(tapGes)

            self.panGes = UIPanGestureRecognizer(target: self, action: #selector(self.drawAction(_:)))
            self.panGes.maximumNumberOfTouches = 1
            self.panGes.delegate = self
            self.containerView.addGestureRecognizer(self.panGes)

            self.stickers.forEach { (view) in
                self.stickersContainer.addSubview(view)
                if let tv = view as? ZLTextStickerView {
                    tv.frame = tv.originFrame
                    self.configTextSticker(tv)
                } else if let iv = view as? ZLImageStickerView {
                    iv.frame = iv.originFrame
                    self.configImageSticker(iv)
                }
            }
            
            //: Add Constraints
            self.setupConstraints()
            self.initListener()
        }
    }

    @available(iOS 9.0, *)
    func setupConstraints() {
        DispatchQueue.main.async {
            //: background image view
            self.backgroundView.widthAnchor.constraint(equalToConstant: 389).isActive = true
            self.backgroundView.heightAnchor.constraint(equalToConstant: 329).isActive = true
            self.backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -10).isActive = true
            self.backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -30).isActive = true

            //: back button
            self.backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true

            //: top label
            self.topLabel.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0).isActive = true
            self.topLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
            
            //: new photo button
            self.newPhotoButton.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor, constant: 0).isActive = true
            self.newPhotoButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true

            //: image container view
            switch GlobalConstants.canvasType
            {
            case 916:
                self.imageContainerView.heightAnchor.constraint(equalToConstant: 600).isActive = true
            case 45:
                self.imageContainerView.heightAnchor.constraint(equalToConstant: 400).isActive = true
            default:
                self.imageContainerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
            }
            self.imageContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
            self.imageContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            self.imageContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -10).isActive = true
            self.imageContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true

            //: selected image view
            self.selectedImage.topAnchor.constraint(equalTo: self.imageContainerView.topAnchor, constant: 0).isActive = true
            self.selectedImage.leadingAnchor.constraint(equalTo: self.imageContainerView.leadingAnchor, constant: 0).isActive = true
            self.selectedImage.trailingAnchor.constraint(equalTo: self.imageContainerView.trailingAnchor, constant: 0).isActive = true
            self.selectedImage.bottomAnchor.constraint(equalTo: self.imageContainerView.bottomAnchor, constant: 0).isActive = true

            //: hidden edit view

            self.hiddenEditView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
            self.hiddenEditView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive = true
            self.hiddenEditView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
            self.hiddenEditView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true

            //: remove edit view
            self.removeEditViewButton.trailingAnchor.constraint(equalTo: self.hiddenEditView.trailingAnchor, constant: -20).isActive = true
            self.removeEditViewButton.topAnchor.constraint(equalTo: self.hiddenEditView.topAnchor, constant: 20).isActive = true

            //: edit image button
            self.editImageButton.trailingAnchor.constraint(equalTo: self.hiddenEditView.trailingAnchor, constant: -20).isActive = true
            self.editImageButton.bottomAnchor.constraint(equalTo: self.hiddenEditView.bottomAnchor, constant: -20).isActive = true

            //: bottom view
            self.bottomBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
            self.bottomBar.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
            self.bottomBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
            self.bottomBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
            self.bottomBar.layer.cornerRadius = 30
            
            //: scroll view
            self.scrollView.backgroundColor = .black
            self.scrollView.minimumZoomScale = 1
            self.scrollView.maximumZoomScale = 3
            self.scrollView.delegate = self
            
            self.scrollView.fillToSuperView()
            self.scrollView.equalsToWidth()
            self.scrollView.equalsToHeight()
            
            
            //: container view
            self.containerView.clipsToBounds = true
            self.containerView.widthAnchor.constraint(equalTo: self.imageContainerView.widthAnchor).isActive = true
            self.containerView.heightAnchor.constraint(equalTo: self.imageContainerView.heightAnchor).isActive = true
            self.containerView.fillToSuperView()
            
            //: image view
            self.imageView.contentMode = .scaleToFill
            self.imageView.clipsToBounds = true
            self.imageView.backgroundColor = .black
            self.imageView.fillToSuperView()
            
            //: drawing image view
            self.drawingImageView.contentMode = .scaleAspectFit
            self.drawingImageView.isUserInteractionEnabled = true
            
            self.drawingImageView.fillToSuperView()
            
            //: sticker image view
            self.stickersContainer.fillToSuperView()
        }
    }

    func initListener() {
        DispatchQueue.main.async {
            //: image view tapped
            let imageViewTapped = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
            self.selectedImage.isUserInteractionEnabled = true
            self.selectedImage.addGestureRecognizer(imageViewTapped)

            //: text sticker view tapped
            let textStickerTapped = UITapGestureRecognizer(target: self, action: #selector(self.textStickerTapped))
            self.addTextView.isUserInteractionEnabled = true
            self.addTextView.addGestureRecognizer(textStickerTapped)


//            self.selectedImage.clipsToBounds = true
//            self.imageContainerView.layer.cornerRadius = 6
//            self.imageContainerView.clipsToBounds = true

            self.bottomBar.layer.applyCornerRadiusShadow(
                color: .black,
                alpha: 0.3,
                cornerRadiusValue: self.bottomBar.layer.cornerRadius
            )
        }
    }

    //MARK: - Public Functions


    //MARK: - Actions
    
    @objc func newPhotoButtonTapped(_ sender: UIButton) {
        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = { (images, assets, isOriginal) in
            DispatchQueue.main.async {
                guard let image = images.first else { return }
                
                self.originalImage = image.mergeWith(topImage: UIImage(named: "merge")!).fixOrientation()
                self.imageView.image = self.originalImage.fixOrientation()
                
                
            }
        }
        ps.showPhotoLibrary(sender: self)
    }

    @objc func textStickerTapped() {
        self.textStickerBtnClick()
    }

    @objc func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //: do something
        }
    }

    @objc func removeEditViewAction(_ sender: UIButton) {
        switch sender.tag
        {
            case 1:
                DispatchQueue.main.async {
                    self.hiddenEditView.alpha = 1
                    self.hiddenEditView.isHidden = false
                }
            case 2:
                DispatchQueue.main.async {
                    self.hiddenEditView.alpha = 0
                    self.removeEditViewButton.alpha = 0
                    self.editImageButton.alpha = 0
                    self.hiddenEditView.isHidden = true
                    self.selectedImage.layer.borderWidth = 0
                    self.isEditActive = false
                }
            default:
                break
        }
    }

    @objc func imageTapped(_ sender: UIImageView) {
        switch isEditActive
        {
            case false:
                DispatchQueue.main.async {
                    self.hiddenEditView.alpha = 1
                    self.removeEditViewButton.alpha = 1
                    self.editImageButton.alpha = 1
                    self.hiddenEditView.isHidden = false
                    self.selectedImage.layer.borderWidth = 1
                    self.selectedImage.layer.borderColor = UIColor.black.cgColor
                    self.isEditActive = true
                }
            case true:
                DispatchQueue.main.async {
                    self.hiddenEditView.alpha = 0
                    self.removeEditViewButton.alpha = 0
                    self.editImageButton.alpha = 0
                    self.hiddenEditView.isHidden = true
                    self.selectedImage.layer.borderWidth = 0
                    self.isEditActive = false
                }
        }
    }

    @objc func editImageTapped(_ sender: UIButton) {
        let ps = ZLPhotoPreviewSheet()
        ps.selectImageBlock = { (images, assets, isOriginal) in
            DispatchQueue.main.async {
                guard let image = images.first else { return }
                
                self.originalImage = image.mergeWith(topImage: UIImage(named: "merge")!).fixOrientation()
                self.imageView.image = self.originalImage.fixOrientation()
                
                
            }
        }
        ps.showPhotoLibrary(sender: self)
    }

    //MARK: - Edit Actions

    func rotationImageView() {
        let transform = CGAffineTransform(rotationAngle: self.angle.toPi)
        self.imageView.transform = transform
        self.drawingImageView.transform = transform
        self.stickersContainer.transform = transform
    }


    func drawBtnClick() {
        let isSelected = self.selectedTool != .draw
        if isSelected {
            self.selectedTool = .draw
        } else {
            self.selectedTool = nil
        }
        self.revokeBtn.isHidden = !isSelected
        self.revokeBtn.isEnabled = self.drawPaths.count > 0
    }

    func clipBtnClick() {
        let currentEditImage = self.buildImage()
        let vc = ZLClipImageViewController(image: currentEditImage, editRect: self.editRect, angle: self.angle, selectRatio: self.selectRatio)
        let rect = self.scrollView.convert(self.containerView.frame, to: self.view)
        vc.presentAnimateFrame = rect
        vc.presentAnimateImage = currentEditImage.clipImage(angle: self.angle, editRect: self.editRect, isCircle: self.selectRatio?.isCircle ?? false)
        vc.modalPresentationStyle = .fullScreen

        vc.clipDoneBlock = { [weak self] (angle, editFrame, selectRatio) in
            guard let `self` = self else { return }
            let oldAngle = self.angle
            let oldContainerSize = self.stickersContainer.frame.size
            if self.angle != angle {
                self.angle = angle
                self.rotationImageView()
            }
            self.editRect = editFrame
            self.selectRatio = selectRatio
            self.resetContainerViewFrame()
            self.reCalculateStickersFrame(oldContainerSize, oldAngle, angle)
        }

        vc.cancelClipBlock = { [weak self] () in
            self?.resetContainerViewFrame()
        }

        self.present(vc, animated: false) {
            self.scrollView.alpha = 0
            self.topShadowView.alpha = 0
            self.bottomShadowView.alpha = 0
        }
    }

    func imageStickerBtnClick() {
        ZLPhotoConfiguration.default().imageStickerContainerView?.show(in: self.view)
        self.setToolView(show: false)
        self.imageStickerContainerIsHidden = false
    }

    func textStickerBtnClick() {
        self.showInputTextVC { [weak self] (text, textColor, bgColor) in
            self?.addTextStickersView(text, textColor: textColor, bgColor: bgColor)
        }
    }

    func mosaicBtnClick() {
        let isSelected = self.selectedTool != .mosaic
        if isSelected {
            self.selectedTool = .mosaic
        } else {
            self.selectedTool = nil
        }

        self.revokeBtn.isHidden = !isSelected
        self.revokeBtn.isEnabled = self.mosaicPaths.count > 0
    }

    func filterBtnClick() {
        let isSelected = self.selectedTool != .filter
        if isSelected {
            self.selectedTool = .filter
        } else {
            self.selectedTool = nil
        }

        self.revokeBtn.isHidden = true
    }

    @objc func doneBtnClick() {
        var textStickers: [(ZLTextStickerState, Int)] = []
        var imageStickers: [(ZLImageStickerState, Int)] = []
        for (index, view) in self.stickersContainer.subviews.enumerated() {
            if let ts = view as? ZLTextStickerView, let _ = ts.label.text {
                textStickers.append((ts.state, index))
            } else if let ts = view as? ZLImageStickerView {
                imageStickers.append((ts.state, index))
            }
        }

        var hasEdit = true
        if self.drawPaths.isEmpty, self.editRect.size == self.imageSize, self.angle == 0, self.mosaicPaths.isEmpty, imageStickers.isEmpty, textStickers.isEmpty, self.currentFilter.applier == nil {
            hasEdit = false
        }

        var resImage = self.originalImage
        var editModel: ZLEditImageModel? = nil
        if hasEdit {
            resImage = self.buildImage()
            resImage = resImage.clipImage(angle: self.angle, editRect: self.editRect, isCircle: self.selectRatio?.isCircle ?? false) ?? resImage
            editModel = ZLEditImageModel(drawPaths: self.drawPaths, mosaicPaths: self.mosaicPaths, editRect: self.editRect, angle: self.angle, selectRatio: self.selectRatio, selectFilter: self.currentFilter, textStickers: textStickers, imageStickers: imageStickers)
        }

        self.dismiss(animated: self.animate) {
            self.editFinishBlock?(resImage, editModel)
        }
    }

    @objc func revokeBtnClick() {
        if self.selectedTool == .draw {
            guard !self.drawPaths.isEmpty else {
                return
            }
            self.drawPaths.removeLast()
            self.revokeBtn.isEnabled = self.drawPaths.count > 0
            self.drawLine()
        } else if self.selectedTool == .mosaic {
            guard !self.mosaicPaths.isEmpty else {
                return
            }
            self.mosaicPaths.removeLast()
            self.revokeBtn.isEnabled = self.mosaicPaths.count > 0
            self.generateNewMosaicImage()
        }
    }

    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        if self.bottomShadowView.alpha == 1 {
            self.setToolView(show: false)
        } else {
            self.setToolView(show: true)
        }
    }

    @objc func drawAction(_ pan: UIPanGestureRecognizer) {
        if self.selectedTool == .draw {
            let point = pan.location(in: self.drawingImageView)
            if pan.state == .began {
                self.setToolView(show: false)

                let originalRatio = min(self.containerView.frame.width / self.originalImage.size.width, self.containerView.frame.height / self.originalImage.size.height)
                let ratio = min(self.containerView.frame.width / self.editRect.width, self.containerView.frame.height / self.editRect.height)
                let scale = ratio / originalRatio
                // 缩放到最初的size
                var size = self.drawingImageView.frame.size
                size.width /= scale
                size.height /= scale
                if self.angle == -90 || self.angle == -270 {
                    swap(&size.width, &size.height)
                }

                var toImageScale = ZLEditImageViewController.maxDrawLineImageWidth / size.width
                if self.editImage.size.width / self.editImage.size.height > 1 {
                    toImageScale = ZLEditImageViewController.maxDrawLineImageWidth / size.height
                }

                let path = ZLDrawPath(pathColor: self.currentDrawColor, pathWidth: self.drawLineWidth / self.scrollView.zoomScale, ratio: ratio / originalRatio / toImageScale, startPoint: point)
                self.drawPaths.append(path)
            } else if pan.state == .changed {
                let path = self.drawPaths.last
                path?.addLine(to: point)
                self.drawLine()
            } else if pan.state == .cancelled || pan.state == .ended {
                self.setToolView(show: true)
                self.revokeBtn.isEnabled = self.drawPaths.count > 0
            }
        } else if self.selectedTool == .mosaic {
            let point = pan.location(in: self.imageView)
            if pan.state == .began {
                self.setToolView(show: false)

                var actualSize = self.editRect.size
                if self.angle == -90 || self.angle == -270 {
                    swap(&actualSize.width, &actualSize.height)
                }
                let ratio = min(self.scrollView.frame.width / self.editRect.width, self.containerView.frame.height / self.editRect.height)

                let pathW = self.mosaicLineWidth / self.scrollView.zoomScale
                let path = ZLMosaicPath(pathWidth: pathW, ratio: ratio, startPoint: point)

                self.mosaicImageLayerMaskLayer?.lineWidth = pathW
                self.mosaicImageLayerMaskLayer?.path = path.path.cgPath
                self.mosaicPaths.append(path)
            } else if pan.state == .changed {
                let path = self.mosaicPaths.last
                path?.addLine(to: point)
                self.mosaicImageLayerMaskLayer?.path = path?.path.cgPath
            } else if pan.state == .cancelled || pan.state == .ended {
                self.setToolView(show: true)
                self.revokeBtn.isEnabled = self.mosaicPaths.count > 0
                self.generateNewMosaicImage()
            }
        }
    }

    func setToolView(show: Bool) {
//        self.topShadowView.layer.removeAllAnimations()
//        self.bottomShadowView.layer.removeAllAnimations()
//        if show {
//            UIView.animate(withDuration: 0.25) {
//                self.topShadowView.alpha = 1
//                self.bottomShadowView.alpha = 1
//            }
//        } else {
//            UIView.animate(withDuration: 0.25) {
//                self.topShadowView.alpha = 0
//                self.bottomShadowView.alpha = 0
//            }
//        }
        
        switch isEditActive
        {
            case false:
                DispatchQueue.main.async {
                    self.hiddenEditView.alpha = 1
                    self.removeEditViewButton.alpha = 1
                    self.editImageButton.alpha = 1
                    self.hiddenEditView.isHidden = false
                    self.selectedImage.layer.borderWidth = 1
                    self.selectedImage.layer.borderColor = UIColor.black.cgColor
                    self.isEditActive = true
                }
            case true:
                DispatchQueue.main.async {
                    self.hiddenEditView.alpha = 0
                    self.removeEditViewButton.alpha = 0
                    self.editImageButton.alpha = 0
                    self.hiddenEditView.isHidden = true
                    self.selectedImage.layer.borderWidth = 0
                    self.isEditActive = false
                }
        }
    }

    func showInputTextVC(_ text: String? = nil, textColor: UIColor? = nil, bgColor: UIColor? = nil, completion: @escaping ( (String, UIColor, UIColor) -> Void )) {
        // Calculate image displayed frame on the screen.
        var r = self.scrollView.convert(self.view.frame, to: self.containerView)
        r.origin.x += self.scrollView.contentOffset.x / self.scrollView.zoomScale
        r.origin.y += self.scrollView.contentOffset.y / self.scrollView.zoomScale
        let scale = self.imageSize.width / self.imageView.frame.width
        r.origin.x *= scale
        r.origin.y *= scale
        r.size.width *= scale
        r.size.height *= scale
        let isCircle = self.selectRatio?.isCircle ?? false
        let bgImage = self.buildImage().clipImage(angle: self.angle, editRect: self.editRect, isCircle: isCircle)?.clipImage(angle: 0, editRect: r, isCircle: isCircle)
        let vc = ZLInputTextViewController(image: bgImage, text: text, textColor: textColor, bgColor: bgColor)

        vc.endInput = { (text, textColor, bgColor) in
            completion(text, textColor, bgColor)
        }

        vc.modalPresentationStyle = .fullScreen
        self.showDetailViewController(vc, sender: nil)
    }

    func getStickerOriginFrame(_ size: CGSize) -> CGRect {
        let scale = self.scrollView.zoomScale
        // Calculate the display rect of container view.
        let x = (self.scrollView.contentOffset.x - self.containerView.frame.minX) / scale
        let y = (self.scrollView.contentOffset.y - self.containerView.frame.minY) / scale
        let w = view.frame.width / scale
        let h = view.frame.height / scale
        // Convert to text stickers container view.
        let r = self.containerView.convert(CGRect(x: x, y: y, width: w, height: h), to: self.stickersContainer)
        let originFrame = CGRect(x: r.minX + (r.width - size.width) / 2, y: r.minY + (r.height - size.height) / 2, width: size.width, height: size.height)
        return originFrame
    }

    /// Add image sticker
    func addImageStickerView(_ image: UIImage) {
        let scale = self.scrollView.zoomScale
        let size = ZLImageStickerView.calculateSize(image: image, width: self.view.frame.width)
        let originFrame = self.getStickerOriginFrame(size)

        let imageSticker = ZLImageStickerView(image: image, originScale: 1 / scale, originAngle: -self.angle, originFrame: originFrame)
        self.stickersContainer.addSubview(imageSticker)
        imageSticker.frame = originFrame
        self.view.layoutIfNeeded()

        self.configImageSticker(imageSticker)
    }

    /// Add text sticker
    func addTextStickersView(_ text: String, textColor: UIColor, bgColor: UIColor) {
        guard !text.isEmpty else { return }
        let scale = self.scrollView.zoomScale
        let size = ZLTextStickerView.calculateSize(text: text, width: self.view.frame.width)
        let originFrame = self.getStickerOriginFrame(size)

        let textSticker = ZLTextStickerView(text: text, textColor: textColor, bgColor: bgColor, originScale: 1 / scale, originAngle: -self.angle, originFrame: originFrame)
        self.stickersContainer.addSubview(textSticker)
        textSticker.frame = originFrame

        self.configTextSticker(textSticker)
    }

    func configTextSticker(_ textSticker: ZLTextStickerView) {
        textSticker.delegate = self
        self.scrollView.pinchGestureRecognizer?.require(toFail: textSticker.pinchGes)
        self.scrollView.panGestureRecognizer.require(toFail: textSticker.panGes)
        self.panGes.require(toFail: textSticker.panGes)
    }

    func configImageSticker(_ imageSticker: ZLImageStickerView) {
        imageSticker.delegate = self
        self.scrollView.pinchGestureRecognizer?.require(toFail: imageSticker.pinchGes)
        self.scrollView.panGestureRecognizer.require(toFail: imageSticker.panGes)
        self.panGes.require(toFail: imageSticker.panGes)
    }

    func reCalculateStickersFrame(_ oldSize: CGSize, _ oldAngle: CGFloat, _ newAngle: CGFloat) {
        let currSize = self.stickersContainer.frame.size
        let scale: CGFloat
        if Int(newAngle - oldAngle) % 180 == 0 {
            scale = currSize.width / oldSize.width
        } else {
            scale = currSize.height / oldSize.width
        }

        self.stickersContainer.subviews.forEach { (view) in
            (view as? ZLStickerViewAdditional)?.addScale(scale)
        }
    }

    func drawLine() {
        let originalRatio = min(self.scrollView.frame.width / self.originalImage.size.width, self.scrollView.frame.height / self.originalImage.size.height)
        let ratio = min(self.scrollView.frame.width / self.editRect.width, self.scrollView.frame.height / self.editRect.height)
        let scale = ratio / originalRatio
        // 缩放到最初的size
        var size = self.drawingImageView.frame.size
        size.width /= scale
        size.height /= scale
        if self.angle == -90 || self.angle == -270 {
            swap(&size.width, &size.height)
        }
        var toImageScale = ZLEditImageViewController.maxDrawLineImageWidth / size.width
        if self.editImage.size.width / self.editImage.size.height > 1 {
            toImageScale = ZLEditImageViewController.maxDrawLineImageWidth / size.height
        }
        size.width *= toImageScale
        size.height *= toImageScale

        UIGraphicsBeginImageContextWithOptions(size, false, self.editImage.scale)
        let context = UIGraphicsGetCurrentContext()
        // 去掉锯齿
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        for path in self.drawPaths {
            path.drawPath()
        }
        self.drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    func generateNewMosaicImage() {
        UIGraphicsBeginImageContextWithOptions(self.originalImage.size, false, self.originalImage.scale)
        if self.tools.contains(.filter), let image = self.filterImages[self.currentFilter.name] {
            image.draw(at: .zero)
        } else {
            self.originalImage.draw(at: .zero)
        }
        let context = UIGraphicsGetCurrentContext()

        self.mosaicPaths.forEach { (path) in
            context?.move(to: path.startPoint)
            path.linePoints.forEach { (point) in
                context?.addLine(to: point)
            }
            context?.setLineWidth(path.path.lineWidth / path.ratio)
            context?.setLineCap(.round)
            context?.setLineJoin(.round)
            context?.setBlendMode(.clear)
            context?.strokePath()
        }

        var midImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let midCgImage = midImage?.cgImage else {
            return
        }

        midImage = UIImage(cgImage: midCgImage, scale: self.editImage.scale, orientation: .up)

        UIGraphicsBeginImageContextWithOptions(self.originalImage.size, false, self.originalImage.scale)
        self.mosaicImage?.draw(at: .zero)
        midImage?.draw(at: .zero)

        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgi = temp?.cgImage else {
            return
        }
        let image = UIImage(cgImage: cgi, scale: self.editImage.scale, orientation: .up)

        self.editImage = image
        self.imageView.image = self.editImage

        self.mosaicImageLayerMaskLayer?.path = nil
    }

    func buildImage() -> UIImage {
        let imageSize = self.originalImage.size

        UIGraphicsBeginImageContextWithOptions(self.editImage.size, false, self.editImage.scale)
        self.editImage.draw(at: .zero)

        self.drawingImageView.image?.draw(in: CGRect(origin: .zero, size: imageSize))

        if !self.stickersContainer.subviews.isEmpty, let context = UIGraphicsGetCurrentContext() {
            let scale = self.imageSize.width / self.stickersContainer.frame.width
            self.stickersContainer.subviews.forEach { (view) in
                (view as? ZLStickerViewAdditional)?.resetState()
            }
            context.concatenate(CGAffineTransform(scaleX: scale, y: scale))
            self.stickersContainer.layer.render(in: context)
            context.concatenate(CGAffineTransform(scaleX: 1/scale, y: 1/scale))
        }

        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgi = temp?.cgImage else {
            return self.editImage
        }
        return UIImage(cgImage: cgi, scale: self.editImage.scale, orientation: .up)
    }


    func generateFilterImages() {
        let size: CGSize
        let ratio = (self.originalImage.size.width / self.originalImage.size.height)
        let fixLength: CGFloat = 200
        if ratio >= 1 {
            size = CGSize(width: fixLength * ratio, height: fixLength)
        } else {
            size = CGSize(width: fixLength, height: fixLength / ratio)
        }
        let thumbnailImage = self.originalImage.resize_vI(size) ?? self.originalImage

        DispatchQueue.global().async {
            self.thumbnailFilterImages = ZLPhotoConfiguration.default().filters.map { $0.applier?(thumbnailImage) ?? thumbnailImage }

            ZLMainAsync {

            }
        }
    }

    func resetContainerViewFrame() {
        self.scrollView.setZoomScale(1, animated: true)
        self.imageView.image = self.editImage

        let editSize = self.editRect.size
        let scrollViewSize = self.scrollView.frame.size
        let ratio = min(scrollViewSize.width / editSize.width, scrollViewSize.height / editSize.height)
        let w = ratio * editSize.width * self.scrollView.zoomScale
        let h = ratio * editSize.height * self.scrollView.zoomScale
        self.containerView.frame = CGRect(x: max(0, (scrollViewSize.width-w)/2), y: max(0, (scrollViewSize.height-h)/2), width: w, height: h)
        if self.selectRatio?.isCircle == true {
            let mask = CAShapeLayer()
            let path = UIBezierPath(arcCenter: CGPoint(x: w / 2, y: h / 2), radius: w / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            mask.path = path.cgPath
            self.containerView.layer.mask = mask
        } else {
            self.containerView.layer.mask = nil
        }
        let scaleImageOrigin = CGPoint(x: -self.editRect.origin.x*ratio, y: -self.editRect.origin.y*ratio)
        let scaleImageSize = CGSize(width: self.imageSize.width * ratio, height: self.imageSize.height * ratio)
        self.imageView.frame = CGRect(origin: scaleImageOrigin, size: scaleImageSize)
        self.mosaicImageLayer?.frame = self.imageView.bounds
        self.mosaicImageLayerMaskLayer?.frame = self.imageView.bounds
        self.drawingImageView.frame = self.imageView.frame
        self.stickersContainer.frame = self.imageView.frame

        // 针对于长图的优化
        if (self.editRect.height / self.editRect.width) > (self.view.frame.height / self.view.frame.width * 1.1) {
            let widthScale = self.view.frame.width / w
            self.scrollView.maximumZoomScale = widthScale
            self.scrollView.zoomScale = widthScale
            self.scrollView.contentOffset = .zero
        } else if self.editRect.width / self.editRect.height > 1 {
            self.scrollView.maximumZoomScale = max(3, self.view.frame.height / h)
        }

        self.originalFrame = self.view.convert(self.containerView.frame, from: self.scrollView)
        self.isScrolling = false
    }

    func finishClipDismissAnimate() {
        self.scrollView.alpha = 1
        UIView.animate(withDuration: 0.1) {
            self.topShadowView.alpha = 1
            self.bottomShadowView.alpha = 1
        }
    }
}

//MARK: - Extensions & Delegates

extension EditPhotoViewController: ZLTextStickerViewDelegate {

    func stickerBeginOperation(_ sticker: UIView) {
        self.setToolView(show: false)
        self.ashbinView.layer.removeAllAnimations()
        self.ashbinView.isHidden = false
        var frame = self.ashbinView.frame
        let diff = self.view.frame.height - frame.minY
        frame.origin.y += diff
        self.ashbinView.frame = frame
        frame.origin.y -= diff
        UIView.animate(withDuration: 0.25) {
            self.ashbinView.frame = frame
        }

        self.stickersContainer.subviews.forEach { (view) in
            if view !== sticker {
                (view as? ZLStickerViewAdditional)?.resetState()
                (view as? ZLStickerViewAdditional)?.gesIsEnabled = false
            }
        }
    }

    func stickerOnOperation(_ sticker: UIView, panGes: UIPanGestureRecognizer) {
        let point = panGes.location(in: self.view)
        if self.ashbinView.frame.contains(point) {
            self.ashbinView.backgroundColor = zlRGB(241, 79, 79).withAlphaComponent(0.98)
            self.ashbinImgView.isHighlighted = true
            if sticker.alpha == 1 {
                sticker.layer.removeAllAnimations()
                UIView.animate(withDuration: 0.25) {
                    sticker.alpha = 0.5
                }
            }
        } else {
            self.ashbinView.backgroundColor = ashbinNormalBgColor
            self.ashbinImgView.isHighlighted = false
            if sticker.alpha != 1 {
                sticker.layer.removeAllAnimations()
                UIView.animate(withDuration: 0.25) {
                    sticker.alpha = 1
                }
            }
        }
    }

    func stickerEndOperation(_ sticker: UIView, panGes: UIPanGestureRecognizer) {
        self.setToolView(show: true)
        self.ashbinView.layer.removeAllAnimations()
        self.ashbinView.isHidden = true

        let point = panGes.location(in: self.view)
        if self.ashbinView.frame.contains(point) {
            (sticker as? ZLStickerViewAdditional)?.moveToAshbin()
        }

        self.stickersContainer.subviews.forEach { (view) in
            (view as? ZLStickerViewAdditional)?.gesIsEnabled = true
        }
    }

    func stickerDidTap(_ sticker: UIView) {
        self.stickersContainer.subviews.forEach { (view) in
            if view !== sticker {
                (view as? ZLStickerViewAdditional)?.resetState()
            }
        }
    }

    func sticker(_ textSticker: ZLTextStickerView, editText text: String) {
        self.showInputTextVC(text, textColor: textSticker.textColor, bgColor: textSticker.bgColor) { [weak self] (text, textColor, bgColor) in
            guard let `self` = self else { return }
            if text.isEmpty {
                textSticker.moveToAshbin()
            } else {
                textSticker.startTimer()
                guard textSticker.text != text || textSticker.textColor != textColor || textSticker.bgColor != bgColor else {
                    return
                }
                textSticker.text = text
                textSticker.textColor = textColor
                textSticker.bgColor = bgColor
                let newSize = ZLTextStickerView.calculateSize(text: text, width: self.view.frame.width)
                textSticker.changeSize(to: newSize)
            }
        }
    }
}


extension EditPhotoViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard self.imageStickerContainerIsHidden else {
            return false
        }
        if gestureRecognizer is UITapGestureRecognizer {
            if self.bottomShadowView.alpha == 1 {
                let p = gestureRecognizer.location(in: self.view)
                return !self.bottomShadowView.frame.contains(p)
            } else {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            guard let st = self.selectedTool else {
                return false
            }
            return (st == .draw || st == .mosaic) && !self.isScrolling
        }

        return true
    }

}


// MARK: scroll view delegate
extension EditPhotoViewController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.containerView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.frame.width > scrollView.contentSize.width) ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0
        let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0
        self.containerView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.isScrolling = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else {
            return
        }
        self.isScrolling = true
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == self.scrollView else {
            return
        }
        self.isScrolling = decelerate
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else {
            return
        }
        self.isScrolling = false
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else {
            return
        }
        self.isScrolling = false
    }
    
}
