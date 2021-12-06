//
//  LoadingButton.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//
import UIKit

class LoadingButton: MainButton {

    struct ButtonState {
        var state: UIControl.State
        var title: String?
        var image: UIImage?
    }

    private (set) var buttonStates: [ButtonState] = []
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = self.titleColor(for: .normal)

        self.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraints([xCenterConstraint, yCenterConstraint])

        return activityIndicator
    }()

    @objc func showLoading() {
        activityIndicator.startAnimating()

        var buttonStates: [ButtonState] = []
        for state in [UIControl.State.disabled] {
            let buttonState = ButtonState(state: state, title: title(for: state), image: image(for: state))
            buttonStates.append(buttonState)
            setTitle("", for: state)
            setImage(UIImage(), for: state)
        }
        self.buttonStates = buttonStates

        isEnabled = false
    }

    @objc func hideLoading() {
        activityIndicator.stopAnimating()

        for buttonState in buttonStates {
            setTitle(buttonState.title, for: buttonState.state)
            setImage(buttonState.image, for: buttonState.state)
        }

        isEnabled = true
    }
}
