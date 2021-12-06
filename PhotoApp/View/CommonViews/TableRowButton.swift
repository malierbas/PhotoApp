//
//  TableRowButton.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UIKit

protocol TableRowButtonDelegate: class {
    func didTap(view: TableRowButton)
}

class TableRowButton: UIButton {
    
    var leftIconImage: UIImage? {
        didSet {
            guard let leftIconImage = leftIconImage else { return }
            setImage(leftIconImage, for: .normal)
            imageEdgeInsets = .init(leftPadding: 24, rightPadding: 20)
            titleEdgeInsets = .init(leftPadding: imageEdgeInsets.left + 20)
        }
    }
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#D8D8D8").withAlphaComponent(0.6)
        return view
    }()

    var hasBottomLineView: Bool = true {
        didSet {
            bottomLineView.isHidden = !hasBottomLineView
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI() {
        addSubview(bottomLineView)
        setupLayout()
    }
    
    private func setupLayout() {
        bottomLineView.anchor(leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        bottomLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
}
