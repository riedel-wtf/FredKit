//
//  FredKitColors.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/1/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import SwiftUI

#if os(iOS)
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
        brightness > 0.5
    }
    
    var goodContrastColor: UIColor {
        isLightColor ? .black : .white
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

@available(iOS 13.0, watchOS 6.0, *)
extension Color {
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}

extension UIColor {
    public convenience init(hex: String) {
        var hex = hex
        if hex.starts(with: "#") {
            hex = String(hex.dropFirst(1))
        }
        
        let r, g, b: CGFloat
        
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat((hexNumber & 0x0000ff)) / 255
            
            self.init(red: r, green: g, blue: b, alpha: 1.0)
            return
        }
        
        self.init(white: 1.0, alpha: 1.0)
    }
    
    @available(iOS 13.0, watchOS 6.0, *)
    public var swiftUI: Color {
        Color(self)
    }
}

#endif

import SwiftUI
public struct LocalizedColor {
    public static var checkMarkColor: Color {
        if Locale.current.regionCode == "CN" {
            return .red
        }
        return .green
    }
    
    public static var xmarkColor: Color {
        if Locale.current.regionCode == "CN" {
            return .green
        }
        return .red
    }
    
    public static var trustworthyColor: Color {
        if Locale.current.regionCode == "CN" {
            return .red
        }
        return .blue
    }
}
