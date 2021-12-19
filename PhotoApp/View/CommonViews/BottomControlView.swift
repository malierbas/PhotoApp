//
//  BottomControlView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//
import UIKit

protocol BottomControlViewDelegate: class {
    func didTapShareButton(onView view: BottomControlView)
    func didTapPreviewButton(onView view: BottomControlView)
    func didTapColorPickerButton(onView view: BottomControlView)
    func didTapStickerPickerButton(onView view: BottomControlView)
    func didTapAddTextButton(onView view: BottomControlView)
}

class BottomControlView: UIView {
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()

    private let previewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "eye")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)
        return button
    }()

    let backgroundSelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "backgroundSelectionIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(colorPickerButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    let addTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "addTextIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(addTextButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    let stickerSelectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "stickerSelectionIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(stickerSelectionButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        return stackView
    }()
    
    private let topSeparatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
    
    weak var delegate: BottomControlViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        backgroundColor = UIColor(hexString: "#1C1F21")
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(addTextButton)
        buttonsStackView.addArrangedSubview(stickerSelectionButton)
        buttonsStackView.addArrangedSubview(backgroundSelectionButton)
        buttonsStackView.addArrangedSubview(previewButton)
        buttonsStackView.addArrangedSubview(saveButton)
        addSubview(topSeparatorLineView)
        setupLayout()
    }
    
    @objc func saveButtonTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapShareButton(onView: self)
    }

    @objc func previewButtonTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapPreviewButton(onView: self)
    }

    @objc func colorPickerButtonTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapColorPickerButton(onView: self)
    }

    @objc func addTextButtonTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapAddTextButton(onView: self)
    }

    @objc func stickerSelectionButtonTapped() {
        UIImpactFeedbackGenerator().impactOccurred()
        self.delegate?.didTapStickerPickerButton(onView: self)
    }
    
    private func setupLayout() {

        buttonsStackView.anchor(top: topAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                padding: .init(topPadding: 12, leftPadding: 24, rightPadding: 24))
        buttonsStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.widthAnchor.constraint(equalTo: saveButton.heightAnchor, multiplier: 1.0).isActive = true

        previewButton.translatesAutoresizingMaskIntoConstraints = false
        previewButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        previewButton.widthAnchor.constraint(equalTo: previewButton.heightAnchor, multiplier: 1.0).isActive = true

        backgroundSelectionButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundSelectionButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        backgroundSelectionButton.widthAnchor.constraint(equalTo: backgroundSelectionButton.heightAnchor, multiplier: 1.0).isActive = true

        topSeparatorLineView.anchor(leading: leadingAnchor, trailing: trailingAnchor)
        topSeparatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

    }
    
}
