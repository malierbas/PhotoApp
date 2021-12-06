//
//  TextFieldView.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

protocol TextFieldViewDelegate: class {
    func willChangeTextFieldText(to text: String, onView view: TextFieldView)
    func textFieldRightViewTapped(onView view: TextFieldView)
}

extension TextFieldViewDelegate {
    func willChangeTextFieldText(to text: String, onView view: TextFieldView) { }
    func textFieldRightViewTapped(onView view: TextFieldView) { }
}

class TextFieldView: UIView {

    let textFieldTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#989898")
        label.text = "Ürün başlığı"
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textField.attributedPlaceholder = NSAttributedString(string: "Örn: Özel geceler için siyah şık çanta", attributes: [
            .foregroundColor: UIColor(hex: "#CECECE"),
            .font: UIFont.systemFont(ofSize: 15, weight: .regular)
            ])
        textField.sizeToFit()
        textField.delegate = self
        textField.autocorrectionType = .no
        return textField
    }()

    private lazy var textFieldBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = bottomLineViewPassiveColor
        return view
    }()

    let textFieldBottomInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .light)
        label.textColor = UIColor(hex: "#F0485C")
        label.text = "Ürün başlığı en az 1 kelime / 5 karakter olmalı"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    var textFieldPlaceholderText: String? {
        didSet {
            guard let textFieldPlaceholderText = textFieldPlaceholderText else { return }
            textField.attributedPlaceholder = NSAttributedString(string: textFieldPlaceholderText, attributes: [
                .foregroundColor: UIColor(hex: "#CECECE"),
                .font: UIFont.systemFont(ofSize: 15, weight: .regular)
                ])
        }
    }

    let bottomLineViewPassiveColor = UIColor(hex: "#EDEDED")

    var shouldHideTitleLabelInteractively: Bool = false {
        didSet {
            textFieldTitleLabel.isHidden = shouldHideTitleLabelInteractively
        }
    }

    var rightImage: UIImage? {
        didSet {
            textField.rightViewMode = .always
            let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
            let rightImageView = UIImageView(image: rightImage)
            rightImageView.isUserInteractionEnabled = true
            rightImageView.frame = CGRect(x: 20, y: 10, width: 20, height: 20)
            rightImageView.contentMode = .scaleAspectFit
            rightView.addSubview(rightImageView)
            textField.rightView = rightView
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldRightViewTapped))
            tapGesture.numberOfTapsRequired = 1
            textField.rightView?.addGestureRecognizer(tapGesture)
        }
    }

    weak var delegate: TextFieldViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func prepareUI() {
        addSubviews(views: textFieldTitleLabel, textField, textFieldBottomLineView, textFieldBottomInfoLabel)
        setupLayout()
        addTapGestureRecognizer()
    }

    private func addTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func viewTapped() {
        self.textField.becomeFirstResponder()
    }

    private func setupLayout() {

        textField.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         padding: .init(topPadding: 8, leftPadding: 20, rightPadding: 20))

        textFieldBottomLineView.anchor(top: textField.bottomAnchor,
                                         leading: textField.leadingAnchor,
                                         trailing: textField.trailingAnchor,
                                         padding: .init(topPadding: 4))
        textFieldBottomLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true

        textFieldBottomInfoLabel.anchor(top: textFieldBottomLineView.bottomAnchor,
                                        leading: leadingAnchor,
                                        trailing: trailingAnchor,
                                        padding: .init(topPadding: 4, leftPadding: 20, rightPadding: 20))
    }

    @objc func textFieldRightViewTapped() {
        self.delegate?.textFieldRightViewTapped(onView: self)
    }
}

extension TextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBottomLineView.backgroundColor = .black
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldBottomLineView.backgroundColor = bottomLineViewPassiveColor

        if shouldHideTitleLabelInteractively {
            if let text = textField.text, text.count > 0 {
                textFieldTitleLabel.isHidden = false
            } else {
                textFieldTitleLabel.isHidden = true
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else { return false }
        let currentUpdatedText = text.replacingCharacters(in: textRange, with: string).trimmingCharacters(in: .whitespaces) // trimming needed for cutting textField's text especially since ios removes white space at the end when text is cut.
        self.delegate?.willChangeTextFieldText(to: currentUpdatedText, onView: self)
        if shouldHideTitleLabelInteractively {
            if currentUpdatedText.count > 0 {
                textFieldTitleLabel.isHidden = false
            } else {
                textFieldTitleLabel.isHidden = true
            }
        }
        return true
    }
}

