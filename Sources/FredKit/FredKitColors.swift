//
//  FredKitColors.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/1/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

#if os(iOS)
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
    
    
    static func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        // add the components, but don't let them go above 1.0
        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }
    
    static func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
    }
    
    static func +(color1: UIColor, color2: UIColor) -> UIColor {
        return addColor(color1, with: color2)
    }
    
    static func *(color: UIColor, multiplier: Double) -> UIColor {
        return multiplyColor(color, by: CGFloat(multiplier))
    }

    
}
#endif
