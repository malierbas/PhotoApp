//
//  StickerView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

@objc protocol StickerViewDelegate: class {
    func didTapRemoveButton(onStickerView stickerView: StickerView)
    @objc optional func didTapEditModeView(onStickerView stickerView: StickerView)
}

class StickerView: UIView, UIGestureRecognizerDelegate {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var sticker: Sticker? {
        didSet {
            imageView.image = sticker?.image
        }
    }

    private lazy var editModeView: StickerViewEditModeView = {
        let view = StickerViewEditModeView(frame: .zero)
        view.isHidden = true
        view.delegate = self
        return view
    }()

    var isSelected: Bool = false {
        didSet {
            self.editModeView.isHidden = !isSelected
        }
    }

    weak var delegate: StickerViewDelegate?

    init(sticker: Sticker) {
        super.init(frame: .zero)
        self.sticker = sticker
        prepareUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func prepareUI() {
        imageView.image = sticker?.image
        addSubview(imageView)
        addSubview(editModeView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognized))
        addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDetected))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)

        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureDetected))
        pinchGestureRecognizer.delegate = self
        addGestureRecognizer(pinchGestureRecognizer)

        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotationGestureDetected))
        rotationGestureRecognizer.delegate = self
        addGestureRecognizer(rotationGestureRecognizer)

        setupLayout()
    }

    private func setupLayout() {
        imageView.fillSuperview()
        editModeView.fillSuperview()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if !(otherGestureRecognizer is UITapGestureRecognizer) {
            return true
        }
        return false
    }


    @objc func tapGestureRecognized() {
        UIImpactFeedbackGenerator().impactOccurred()
        isSelected.toggle()
    }

    @objc func panGestureDetected(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        let gestureView = gestureRecognizer.view!
        // Get the changes in the X and Y directions relative to
        // the superview's coordinate space.
        let translation = gestureRecognizer.translation(in: gestureView.superview)

        if gestureRecognizer.state == .began {
            print("gestureRecognizer.state: .began")
            // Save the view's original position.
            sticker?.latestCenter = gestureView.center
        }
        // Update the position for the .began, .changed, and .ended states
        if gestureRecognizer.state != .cancelled {
            print("gestureRecognizer.state: !.cancelled")
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: sticker!.latestCenter.x + translation.x, y: sticker!.latestCenter.y + translation.y)
            gestureView.center = newCenter
        } else {
            print("gestureRecognizer.state: .cancelled")
            // On cancellation, return the gestureView to its original location.
            gestureView.center = sticker!.latestCenter
        }

        if gestureRecognizer.state == .began || gestureRecognizer.state == .ended {
            print("saving latest center: \(gestureView.center)")
            sticker?.latestCenter = gestureView.center
        }

        //        gestureRecognizer.setTranslation(.zero, in: gestureView)
    }

    @objc func pinchGestureDetected(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else {
            return
        }

        gestureView.transform = gestureView.transform.scaledBy(
            x: gestureRecognizer.scale * gestureRecognizer.scale * gestureRecognizer.scale,
            y: gestureRecognizer.scale * gestureRecognizer.scale * gestureRecognizer.scale
        )
        gestureRecognizer.scale = 1
    }

    @objc func rotationGestureDetected(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else {
            return
        }

        gestureView.transform = gestureView.transform.rotated(by: gestureRecognizer.rotation)
        gestureRecognizer.rotation = 0
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let moreSensibleRectangle = bounds.insetBy(dx: -60, dy: -60)
        return moreSensibleRectangle.contains(point)
    }

}

extension StickerView: StickerViewEditModeViewDelegate {
    func didTapRemoveButton(onView view: StickerViewEditModeView) {
        self.delegate?.didTapRemoveButton(onStickerView: self)
    }
    func didTapEditModeView(onView view: StickerViewEditModeView) {
        isSelected.toggle()
    }
}


