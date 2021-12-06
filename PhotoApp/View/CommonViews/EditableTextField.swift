//
//  EditableTextField.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol EditableTextFieldDelegate: class {
    @objc optional func didTapRemoveButton(onTextFieldView textFieldView: EditableTextField)
}

class EditableTextField: UITextField, UIGestureRecognizerDelegate {

    private lazy var editModeView: EditableTextEditModeView = {
        let view = EditableTextEditModeView(frame: .zero)
        view.isHidden = true
        view.delegate = self
        return view
    }()

    var model: Template.CanvasText? {
        didSet {
            populateView(withModel: model)
        }
    }

    override var isSelected: Bool {
        didSet {
            self.editModeView.isHidden = !isSelected
        }
    }

    weak var editableTextFieldDelegate: EditableTextFieldDelegate?

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

    private func prepareUI() {
        tintColor = .black
        autocorrectionType = .no
        textAlignment = .center
        contentVerticalAlignment = .center
        clipsToBounds = false
        addSubview(editModeView)

        // add gesture recognizer for tap
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizedTap))
        tapGestureRecognizer.numberOfTapsRequired = 1
        addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDetected))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)

        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureDetected))
        rotationGestureRecognizer.delegate = self
        addGestureRecognizer(rotationGestureRecognizer)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)

//        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureDetected))
//        pinchGestureRecognizer.delegate = self
//        addGestureRecognizer(pinchGestureRecognizer)

        setupLayout()
    }

    private func setupLayout() {
        editModeView.fillSuperview()
    }

    private func populateView(withModel model: Template.CanvasText?) {
        guard let model = model else { return }
        text = model.text
        font = model.font
        textColor = model.textColor
        textAlignment = model.textAlignment ?? .center
    }

    override var canBecomeFirstResponder: Bool {
        return isSelected
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func didRecognizedTap() {
        UIImpactFeedbackGenerator().impactOccurred()
        isSelected.toggle()
        if isFirstResponder {
            resignFirstResponder()
        }
    }

    @objc func panGestureDetected(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        let gestureView = gestureRecognizer.view!

        // handle edge pan if necessary and return in that case
        let panLocation = gestureRecognizer.location(in: self)
        let edgePanSensitivityAmount: CGFloat = 16
        if panLocation.x < edgePanSensitivityAmount || (panLocation.x > (gestureView.frame.width - edgePanSensitivityAmount)) {
            if isSelected {
                handleEdgePan(for: gestureRecognizer)
                return
            }
        }

        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: gestureView.superview)

        if gestureRecognizer.state == .began {
            print("gestureRecognizer.state: .began")
            // Save the view's original position.
            model?.latestCenter = gestureView.center
        }
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            print("gestureRecognizer.state: !.cancelled")
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: model!.latestCenter.x + translation.x, y: model!.latestCenter.y + translation.y)
            gestureView.center = newCenter
        } else {
            print("gestureRecognizer.state: .cancelled")
            // On cancellation, return the gestureView to its original location.
            gestureView.center = model!.latestCenter
        }

        if gestureRecognizer.state == .began || gestureRecognizer.state == .ended {
            print("saving latest center: \(gestureView.center)")
            model?.latestCenter = gestureView.center
        }

        if Int(gestureView.superview?.center.x ?? 0) == Int(self.center.x) || Int(gestureView.superview?.center.y ?? 0) == Int(self.center.y) {
            UIImpactFeedbackGenerator().impactOccurred()
        }

//        gestureRecognizer.setTranslation(.zero, in: gestureView)
    }

    private func handleEdgePan(for gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        let gestureView = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: gestureView.superview)

        let edgePanSensitivityAmount: CGFloat = 16
        let panLocation = gestureRecognizer.location(in: self)

        if panLocation.x < edgePanSensitivityAmount {
            print("panning from left with translation: ", translation)
            frame.size = CGSize(width: frame.width - translation.x, height: frame.height)
            let newCenter = CGPoint(x: center.x + translation.x, y: center.y)
            gestureView.center = newCenter
        } else if (panLocation.x > (gestureView.frame.width - edgePanSensitivityAmount)) {
            print("panning from right with translation: ", translation)
            frame.size = CGSize(width: frame.width + translation.x, height: frame.height)
        }

        gestureRecognizer.setTranslation(.zero, in: gestureView)
    }

    @objc func pinchGestureDetected(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else {
            return
        }

        gestureView.transform = gestureView.transform.scaledBy(
            x: gestureRecognizer.scale,
            y: gestureRecognizer.scale
        )

        if let currentFontSize = font?.pointSize {
            let newFontSize = currentFontSize * gestureRecognizer.scale
            font = font?.withSize(newFontSize)
        }

        gestureRecognizer.scale = 1
    }

    @objc func rotationGestureDetected(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else {
            return
        }

        gestureView.transform = gestureView.transform.rotated(by: gestureRecognizer.rotation)
        gestureRecognizer.rotation = 0
    }

    @objc func handleDoubleTap() {
        editModeView.editTextTapped()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let moreSensibleRectangle = bounds.insetBy(dx: -20, dy: -20)
        return moreSensibleRectangle.contains(point)
    }

}

extension EditableTextField: EditableTextEditModeViewDelegate {
    func didTapRemoveButton(onView view: EditableTextEditModeView) {
        self.editableTextFieldDelegate?.didTapRemoveButton?(onTextFieldView: self)
        removeFromSuperview()
    }

    func didTapEditButton(onView view: EditableTextEditModeView) {
        becomeFirstResponder()
        isSelected.toggle()
    }

    func didTapEditModeView(onView view: EditableTextEditModeView) {
        isSelected.toggle()
    }
}
