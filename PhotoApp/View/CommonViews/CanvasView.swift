//
//  CanvasView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol CanvasViewDelegate: class {
    func didTap(imagePickerView: EditableImageView, onView view: CanvasView)
    @objc optional func didTapRemoveButton(onEditableImageView editableImageView: EditableImageView, onCanvasView canvasView: CanvasView)
    @objc optional func didTapEditButton(onEditableImageView editableImageView: EditableImageView, onCanvasView canvasView: CanvasView)
    @objc optional func didTapEditModeView(onEditableImageView editableImageView: EditableImageView, onCanvasView canvasView: CanvasView)
    @objc optional func didTapRemoveButton(onStickerView stickerView: StickerView, onCanvasView canvasView: CanvasView)
}

class CanvasView: UIView {

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(hexString: "#021B32")
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var gradientLayerView: GradientLayerView = {
        let gradientLayerView = GradientLayerView()
        gradientLayerView.clipsToBounds = true
        gradientLayerView.isHidden = true
        return gradientLayerView
    }()

    var imageViews: [UIView] = []
    var textFields: [EditableTextField] = []
    var stickerViews: [StickerView] = []

    var hasInitializedViews: Bool = false

    var template: Template?

    weak var delegate: CanvasViewDelegate?

    var scaleRatio: CGFloat = 1

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    init(template: Template?) {
        super.init(frame: .zero)
        self.template = template
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func prepareUI() {
        clipsToBounds = true
        addSubview(backgroundImageView)
        
        switch GlobalConstants.canvasType
        {
            case 916, 11, 45:
                if let canvasImages = template?.canvasImages {
                    for canvasImage in canvasImages {
                        if canvasImage.isPicker {
                            let editableImageView = EditableImageView(frame: .zero)
                            editableImageView.delegate = self
                            editableImageView.canvasImage = canvasImage
                            addSubview(editableImageView)
                            imageViews.append(editableImageView)
                        } else {
                            let staticImageView = UIImageView(frame: .zero)
                            staticImageView.contentMode = .scaleAspectFit
                            staticImageView.image = canvasImage.defaultImage
                            addSubview(staticImageView)
                            imageViews.append(staticImageView)
                        }
                    }
                }
            
                break
            default:
                backgroundImageView.addSubview(gradientLayerView)
                if let canvasImages = template?.canvasImages {
                    for canvasImage in canvasImages {
                        if canvasImage.isPicker {
                            let editableImageView = EditableImageView(frame: .zero)
                            editableImageView.delegate = self
                            editableImageView.canvasImage = canvasImage
                            addSubview(editableImageView)
                            imageViews.append(editableImageView)
                        } else {
                            let staticImageView = UIImageView(frame: .zero)
                            staticImageView.contentMode = .scaleAspectFit
                            staticImageView.image = canvasImage.defaultImage
                            addSubview(staticImageView)
                            imageViews.append(staticImageView)
                        }
                    }
                }
                break
        }

   
        if let canvasTexts = template?.canvasTexts {
            for canvasText in canvasTexts {
                let editableTextField = EditableTextField(frame: .zero)
                editableTextField.model = canvasText
                editableTextField.delegate = self
                editableTextField.editableTextFieldDelegate = self
                addSubview(editableTextField)
                textFields.append(editableTextField)
            }
        }
        
        setupLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if !hasInitializedViews {
            initializeFrames()
            hasInitializedViews = true
        }
    }

    private func setupLayout() {
        backgroundImageView.fillSuperview()
        gradientLayerView.fillSuperview()
    }

    private func initializeFrames() {

        if let canvasImages = template?.canvasImages {
            for (index, canvasImage) in canvasImages.enumerated() {
                if let frame1080x1920 = canvasImage.frame1080x1920 {
                    self.imageViews[index].frame = convert1080x1920FrameToPointsFrame(frame1080x1920: frame1080x1920)
                }
            }
        }

        if let canvasTexts = template?.canvasTexts {
            for (index, canvasText) in canvasTexts.enumerated() {
                if let frame1080x1920 = canvasText.frame1080x1920 {
                    self.textFields[index].frame = convert1080x1920FrameToPointsFrame(frame1080x1920: frame1080x1920)
                    self.textFields[index].model?.latestCenter = self.textFields[index].center
                }
            }
        }
    }

    func clearAllEditModes() {
        imageViews.forEach { (imageView) in
            if let editableImageView = imageView as? EditableImageView {
                editableImageView.isSelected = false
            }
        }
        textFields.forEach({ $0.isSelected = false })

        stickerViews.forEach({ $0.isSelected = false })
    }

    private func convert1080x1920FrameToPointsFrame(frame1080x1920: CGRect) -> CGRect {
        let xInCanvasFrame: CGFloat = frame1080x1920.origin.x * self.frame.width / canvasOriginalWidth
        let yInCanvasFrame: CGFloat = frame1080x1920.origin.y * self.frame.height / canvasOriginalHeight
        let widthInCanvasFrame: CGFloat = frame1080x1920.size.width * self.frame.width / canvasOriginalWidth
        let heightInCanvasFrame: CGFloat = frame1080x1920.size.height * self.frame.height / canvasOriginalHeight
        return CGRect(x: xInCanvasFrame, y: yInCanvasFrame, width: widthInCanvasFrame, height: heightInCanvasFrame)
    }

    func refreshBackground() {
      
        //: canvas view
        switch GlobalConstants.canvasType
        {
            case 916, 11, 45:
                if let gradientLayerView = template?.background?.gradientLayerView {
                    
                    if let mainView = self.imageViews.first as? EditableImageView
                    {
                        mainView.backgroundImageView.isHidden = true
                        
                        mainView.gradientLayerView.isHidden = false
                        mainView.gradientLayerView.colors = gradientLayerView.colors
                        mainView.gradientLayerView.locations = gradientLayerView.locations
                        mainView.gradientLayerView.startPoint = gradientLayerView.startPoint
                        mainView.gradientLayerView.endPoint = gradientLayerView.endPoint
                        mainView.gradientLayerView.layoutSubviews()
                        print("memo 1")
                    }
                } else {
                    self.gradientLayerView.isHidden = true
                    
                    if let mainView = self.imageViews.first as? EditableImageView
                    {
                        mainView.gradientLayerView.isHidden = true
                        mainView.backgroundImageView.isHidden = false
                        mainView.backgroundImageView.image = template?.background?.image
                        mainView.backgroundImageView.backgroundColor = template?.background?.color
                        mainView.backgroundImageView.contentMode = .scaleToFill
                        print("memo 2")
                    }
                }
                break
            default:
            
                if let canBeAssignedFullBackground = template?.canBeAssignedFullBackground,
                    let indexOfImageFillingCanvasFully = template?.canvasImages?.firstIndex( where: { $0.frame1080x1920 == CGRect(x: 0, y: 0, width: 1080, height: 1920) }), canBeAssignedFullBackground {
                    imageViews[indexOfImageFillingCanvasFully].isHidden = true
                }
                
            
                backgroundImageView.image = template?.background?.image
                backgroundColor = template?.background?.color

                if let gradientLayerView = template?.background?.gradientLayerView {
                    self.gradientLayerView.isHidden = false
                    self.gradientLayerView.colors = gradientLayerView.colors
                    self.gradientLayerView.locations = gradientLayerView.locations
                    self.gradientLayerView.startPoint = gradientLayerView.startPoint
                    self.gradientLayerView.endPoint = gradientLayerView.endPoint
                    self.gradientLayerView.layoutSubviews()
                } else {
                    self.gradientLayerView.isHidden = true
                }
                break
        }
    }

    func refreshImageViews() {
        guard let canvasImages = template?.canvasImages else { return }
        for (index, canvasImage) in canvasImages.enumerated() {
            if let editableCanvasImageView = imageViews[index] as? EditableImageView {
                editableCanvasImageView.canvasImage = canvasImage
                editableCanvasImageView.layoutSubviews()
            } else if let nonEditableCanvasImageView = imageViews[index] as? UIImageView {
                nonEditableCanvasImageView.image = canvasImage.defaultImage
            }
        }
    }
    
    func hideNonEditableView() {
        guard let canvasImages = template?.canvasImages else { return }
        for (index, canvasImage) in canvasImages.enumerated() {
            if let editableCanvasImageView = imageViews[index] as? EditableImageView {
                editableCanvasImageView.canvasImage = canvasImage
                editableCanvasImageView.layoutSubviews()
            } else if let nonEditableCanvasImageView = imageViews[index] as? UIImageView {
                nonEditableCanvasImageView.image = canvasImage.defaultImage
                nonEditableCanvasImageView.alpha = 0
            }
        }
    }

    func refreshTextFields(withScaleRatio scaleRatio: CGFloat = 1) {
        guard let canvasTexts = template?.canvasTexts else { return }

        for (index, canvasText) in canvasTexts.enumerated() {
            let editableTextField = textFields[index]
            editableTextField.text = canvasText.text
            editableTextField.textColor = canvasText.textColor
            editableTextField.font = canvasText.font
            print("canvasText.latestCenter: \(canvasText.latestCenter)")
            print("editableTextField.center: \(editableTextField.center)")
            let scaledCenter = canvasText.latestCenter
            editableTextField.center = scaledCenter.applying(CGAffineTransform.init(scaleX: scaleRatio, y: scaleRatio))
            print("-after transformation: canvasText.latestCenter: \(canvasText.latestCenter)")
            print("-after transformation: editableTextField.center: \(editableTextField.center)")
        }
    }
}

extension CanvasView: EditableImageViewDelegate {
    func didTap(editableImageView: EditableImageView) {
        self.delegate?.didTap(imagePickerView: editableImageView, onView: self)
    }

    func didTapEditButton(editableImageView: EditableImageView) {
        self.delegate?.didTapEditButton?(onEditableImageView: editableImageView, onCanvasView: self)
    }

    func didTapRemoveButton(editableImageView: EditableImageView) {
        self.delegate?.didTapRemoveButton?(onEditableImageView: editableImageView, onCanvasView: self)
    }

    func didTapEditModeView(onEditableImageView editableImageView: EditableImageView) {
        self.delegate?.didTapEditModeView?(onEditableImageView: editableImageView, onCanvasView: self)
    }
}

extension CanvasView: StickerViewDelegate {

    func didTapRemoveButton(onStickerView stickerView: StickerView) {
        self.delegate?.didTapRemoveButton?(onStickerView: stickerView, onCanvasView: self)
    }
}


extension CanvasView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let indexOfTextField = textFields.firstIndex(where: { $0 === textField }) {
            template?.canvasTexts?[indexOfTextField].text = textField.text
        }
    }
}

extension CanvasView: EditableTextFieldDelegate {
    func didTapRemoveButton(onTextFieldView textFieldView: EditableTextField) {
        guard let indexOfTextField = textFields.firstIndex(where: { $0 === textFieldView }) else { return }
        template?.canvasTexts?.remove(at: indexOfTextField)
        self.textFields.remove(at: indexOfTextField)
    }
}
