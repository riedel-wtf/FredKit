//
//  File.swift
//  
//
//  Created by Frederik Riedel on 05.11.21.
//

import Foundation

//
//  FredKitButton.swift
//  FredKit
//
//  Created by Frederik Riedel on 6/17/20.
//  Copyright © 2020 Frogg GmbH. All rights reserved.
//
import UIKit

enum FredKitButtonStyle {
    case filled, bordered, empty
}

@IBDesignable class FredKitButton: UIButton {

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
    
    override var tintColor: UIColor! {
        didSet {
            super.tintColor = tintColor
            refreshUI()
        }
    }
    
    override func awakeFromNib() {
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
    
}
