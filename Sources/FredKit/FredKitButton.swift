//
//  FredKitButton.swift
//  FredKit
//
//  Created by Frederik Riedel on 6/17/20.
//  Copyright © 2020 Frogg GmbH. All rights reserved.
//

#if !os(watchOS)
import Foundation
import UIKit

public enum FredKitButtonStyle {
    case filled, bordered, empty
}

@IBDesignable public class FredKitButton: UIButton {

    var cornerRadius: CGFloat! = 16 {
        didSet {
            refreshUI()
        }
    }
    
    var style: FredKitButtonStyle! = .filled {
        didSet {
            refreshUI()
        }
    }
    
    public override var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            refreshUI()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        refreshUI()
    }
    
    private func refreshUI() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.masksToBounds = true
        
        switch style {
        case .filled:
            self.backgroundColor = tintColor
            self.setTitleColor(tintColor.goodContrastColor, for: .normal)
            self.layer.borderWidth = 0
        case .bordered:
            self.backgroundColor = .clear
            self.layer.borderWidth = 2.0
            self.layer.borderColor = tintColor.cgColor
            self.setTitleColor(tintColor, for: .normal)
        case .empty:
            self.backgroundColor = .clear
            self.layer.borderWidth = 0
            self.setTitleColor(tintColor, for: .normal)
        case .none:
            self.backgroundColor = .clear
        }
        
    }
    
    struct ButtonState {
        var state: UIControl.State
        var title: NSAttributedString?
        var image: UIImage?
    }
    
    private (set) var buttonStates: [ButtonState] = []
    private lazy var activityIndicator: UIActivityIndicatorView = {
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
    
    @objc public func showLoading() {
        activityIndicator.startAnimating()
        var buttonStates: [ButtonState] = []
        for state in [UIControl.State.disabled] {
            let buttonState = ButtonState(state: state, title: attributedTitle(for: state), image: image(for: state))
            buttonStates.append(buttonState)
            setAttributedTitle(NSAttributedString(string: ""), for: state)
            setTitle("", for: state)
            setImage(UIImage(), for: state)
        }
        self.buttonStates = buttonStates
        isEnabled = false
    }
    
    @objc public func hideLoading() {
        activityIndicator.stopAnimating()
        for buttonState in buttonStates {
            setAttributedTitle(buttonState.title, for: buttonState.state)
            setImage(buttonState.image, for: buttonState.state)
        }
        isEnabled = true
    }
    
}
#endif
