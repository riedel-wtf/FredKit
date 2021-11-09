//
//  FredKitColors.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/1/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    var brightness: CGFloat {
        var red : CGFloat = 0
        var green : CGFloat = 0
        var blue : CGFloat = 0
        var alpha : CGFloat = 0
        
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (0.2126 * red + 0.7152 * green + 0.0722 * blue)
        }
        
        return 0
    }
    
    var isLightColor: Bool {
        return brightness > 0.5
    }
    
    var goodContrastColor: UIColor {
        if isLightColor {
            return .black
        }
        
        return .white
    }
}
