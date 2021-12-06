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
        return imageView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.layer.borderWidth = 0.5
        scrollView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.8).cgColor
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.maximumZoomScale = 100.0
        scrollView.minimumZoomScale = 0.01
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
        scrollView.addSubview(plusButton)
        scrollView.addSubview(imageView)

        editModeView.padding += canvasImage?.cornerRadius ?? 0

        // add gesture recognizer for tap
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizedTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapGestureRecognizer)

        setupLayout()
    }

    private func setupLayout() {
        scrollView.fillSuperview()
        imageView.fillSuperview()
        editModeView.fillSuperview()

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
            self.canvasImage?.scrollContentOffset = scrollView.contentOffset
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        self.canvasImage?.scrollContentOffset = scrollView.contentOffset
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        print("scrollView.contentOffset: \(scrollView.contentOffset)")
        self.canvasImage?.scrollZoomScale = scrollView.zoomScale
        self.canvasImage?.scrollContentOffset = scrollView.contentOffset
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
