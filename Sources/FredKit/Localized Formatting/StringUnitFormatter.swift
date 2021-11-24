//
//  StringUnitFormatter.swift
//  Boulder Buddy
//
//  Created by Frederik Riedel on 8/26/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import UIKit

struct StringUnitFormatter {
    
    private static func font(withSize size: Double, weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: CGFloat(size), weight: weight).rounded
    }
    
    public static func formattedString(fromString string: String, fontSize: Double, unit: String, fontWeight: UIFont.Weight, unitColor: UIColor?) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(NSAttributedString(string: string, attributes: [.font: font(withSize: fontSize, weight: fontWeight)] ))
        
        if let color = unitColor {
            attributedString.append(NSAttributedString(string: unit.uppercased(), attributes: [.font: font(withSize: 0.8*fontSize, weight: fontWeight), .foregroundColor : color] ))
        } else {
            attributedString.append(NSAttributedString(string: unit.uppercased(), attributes: [.font: font(withSize: 0.8*fontSize, weight: fontWeight)] ))
        }
        
        return NSAttributedString(attributedString: attributedString)
    }
    
    public static func formattedString(fromString string: String, fontSize: Double, unit: String) -> NSAttributedString {
        return formattedString(fromString: string, fontSize: fontSize, unit: unit, fontWeight: .regular, unitColor: nil)
    }
    
    public static func formattedString(fromString string: String, fontSize: Double, unit: String, fontWeight: UIFont.Weight) -> NSAttributedString {
        return formattedString(fromString: string, fontSize: fontSize, unit: unit, fontWeight: fontWeight, unitColor: nil)
    }
    
}
