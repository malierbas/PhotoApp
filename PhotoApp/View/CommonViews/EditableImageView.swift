//
//  EditableImageView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol EditableImageViewDelegate: class {
    func didTap(editableImageView: EditableImageView)
    @objc optional func didTapRemoveButton(editableImageView: EditableImageView)
    @objc optional func didTapEditButton(editableImageView: EditableImageView)
    @objc optional func didTapEditModeView(onEditableImageView editableImageView: EditableImageView)
}

class EditableImageView: UIView, UIGestureRecognizerDelegate {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var gradientLayerView: GradientLayerView = {
        let gradientLayerView = GradientLayerView()
        gradientLayerView.clipsToBounds = true
        gradientLayerView.isHidden = true
        return gradientLayerView
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(hexString: "#021B32")
        imageView.clipsToBounds = true
        return imageView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.layer.borderWidth = 0
        scrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.maximumZoomScale = 100.0
        scrollView.minimumZoomScale = 0.001
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plusIcon"), for: .normal)
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var editModeView: EditableImageEditModeView = {
        let view = EditableImageEditModeView(frame: .zero)
        view.isHidden = true
        view.delegate = self
        return view
    }()

    weak var delegate: EditableImageViewDelegate?

    var isSelected: Bool = false {
        didSet {
            self.editModeView.isHidden = !isSelected
        }
    }

    var canvasImage: Template.CanvasImage? {
        didSet {
            if oldValue == nil {
                imageView.image = canvasImage?.defaultImage
            } else {
                imageView.image = canvasImage?.userPickedImage ?? canvasImage?.defaultImage
            }
        }
    }

    var shouldTryToFitImage: Bool = true
    
    //: image gestures
    var panGesture = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    var rotationGesture = UIRotationGestureRecognizer()

    init() {
        super.init(frame: .zero)
        prepareUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if shouldTryToFitImage {
            tryToFitImage()
            shouldTryToFitImage = false
        } else {
            adjustImageScrolls()
        }
    }

    private func prepareUI() {
        addSubview(scrollView)
        addSubview(editModeView)
        scrollView.addSubview(gradientLayerView)
        scrollView.addSubview(backgroundImageView)
        scrollView.addSubview(plusButton)
        scrollView.addSubview(imageView)

        editModeView.padding += canvasImage?.cornerRadius ?? 0

        // add gesture recognizer for tap
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizedTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapGestureRecognizer)

        setupLayout()
        
        //: gestures for decelerate to image
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didPanGesture))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.didPinchGesture))
        rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateGesture))
        
        self.imageView.addGestureRecognizer(panGesture)
        self.imageView.addGestureRecognizer(pinchGesture)
        self.imageView.addGestureRecognizer(rotationGesture)
    }

    private func setupLayout() {
        scrollView.fillSuperview()
        imageView.fillSuperview()
        editModeView.fillSuperview()
        
        gradientLayerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        gradientLayerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gradientLayerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gradientLayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        gradientLayerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        plusButton.anchorCenterSuperview()
        plusButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        plusButton.heightAnchor.constraint(equalTo: plusButton.widthAnchor, multiplier: 1.0).isActive = true
    }

    private func tryToFitImage() {
        guard let canvasImage = canvasImage else { return }
        let scaleRatio = self.frame.width / (canvasImage.frame1080x1920?.width ?? 0)

        layer.cornerRadius = canvasImage.cornerRadius * scaleRatio
        clipsToBounds = true
        editModeView.layer.cornerRadius = canvasImage.cornerRadius * scaleRatio

        let imageWidth = imageView.image?.size.width ?? 0
        let imageHeight = imageView.image?.size.height ?? 0

        let originalHeightScale = imageHeight / frame.height
        let originalWidthScale = imageWidth / frame.width
        
        let minScale = min(originalHeightScale, originalWidthScale)
        
        let sizeToZoom = CGSize(width: (frame.width * minScale), height: (frame.height * minScale))
        scrollView.zoom(to: CGRect(origin: .zero, size: sizeToZoom), animated: true)
    }

    func adjustImageScrolls(byScaleRatio scaleRatio: CGFloat = 1) {
        guard let canvasImage = canvasImage else { return }

        if let scrollContentOffset = canvasImage.scrollContentOffset {
            scrollView.setContentOffset(scrollContentOffset.applying(CGAffineTransform.init(scaleX: scaleRatio, y: scaleRatio)), animated: false)
        }

        if let scrollZoomScale = canvasImage.scrollZoomScale {
            scrollView.setZoomScale(scrollZoomScale * scaleRatio, animated: false)
        }
    }

    @objc func plusButtonTapped () {
        self.delegate?.didTap(editableImageView: self)
    }

    @objc func didRecognizedTap() {
        self.delegate?.didTap(editableImageView: self)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didPanGesture(sender:UIPanGestureRecognizer){
         
        guard let object = sender.view else { return }
        let tappedImage = object as! UIImageView

        let panelRadius = self.frame.size.width
        let translation = sender.translation(in: self.imageView)
        var newX = object.center.x + translation.x
        var newY = object.center.y + translation.y
        let r = sqrt((newX - self.center.x) * (newX - self.center.x) + (newY - self.center.y) * (newY - self.center.y))
        if (r > panelRadius ){
            newX = object.center.x
            newY = object.center.y
        }
          
        object.center = CGPoint(x: newX, y: newY)
        sender.setTranslation(CGPoint.zero, in: self.imageView)
    }

    @objc func didPinchGesture(gesture: UIPinchGestureRecognizer) {
        if let selectedImage = gesture.view {
            let tappedImage = selectedImage as! UIImageView 
             
            selectedImage.transform = selectedImage.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
        }
    }
    
    @objc func didRotateGesture(gesture: UIRotationGestureRecognizer) {
        
        if let selectedImage = gesture.view {
            selectedImage.transform = selectedImage.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
            
            let tappedImage = selectedImage as! UIImageView
        }
    }
}

extension EditableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x > 0 && scrollView.contentOffset.y > 0 else { return }
        guard scrollView.contentOffset.x < scrollView.contentSize.width && scrollView.contentOffset.y < scrollView.contentSize.height else { return }
        if (scrollView.isTracking || scrollView.isDragging) && !scrollView.isDecelerating && !scrollView.isZooming {
            print("setting content offset with scrollViewDidScroll to: \(scrollView.contentOffset)")
            print("scrollView.isTracking: \(scrollView.isTracking)")
            print("scrollView.isDragging: \(scrollView.isDragging)")
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        self.canvasImage?.scrollContentOffset = scrollView.contentOffset
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        print("scrollView.contentOffset: \(scrollView.contentOffset)")
    }
}


extension EditableImageView: EditableImageEditModeViewDelegate {
    func didTapEditButton(onView view: EditableImageEditModeView) {
        self.delegate?.didTapEditButton?(editableImageView: self)
    }

    func didTapRemoveButton(onView view: EditableImageEditModeView) {
        self.delegate?.didTapRemoveButton?(editableImageView: self)
    }

    func didTapEditModeView(onView view: EditableImageEditModeView) {
        self.delegate?.didTapEditModeView?(onEditableImageView: self)
    }
}
