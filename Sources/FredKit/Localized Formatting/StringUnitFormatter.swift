//
//  StringUnitFormatter.swift
//  Boulder Buddy
//
//  Created by Frederik Riedel on 8/26/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import SwiftUI

public struct StringUnitFormatter {

    private static func font(withSize size: Double, weight: Font.Weight) -> Font {
        return .system(size: size, weight: weight, design: .rounded)
    }

    public static func formattedString(fromString string: String, fontSize: Double, unit: String, fontWeight: Font.Weight, unitColor: Color?) -> AttributedString {
        var attributedString = AttributedString(string)
        attributedString.font = font(withSize: fontSize, weight: fontWeight)

        var unitString = AttributedString(unit.uppercased())
        unitString.font = font(withSize: 0.8 * fontSize, weight: fontWeight)

        if let unitColor {
            unitString.foregroundColor = unitColor
        }

        attributedString.append(unitString)

        return attributedString
    }

    public static func formattedString(fromString string: String, fontSize: Double, unit: String) -> AttributedString {
        return formattedString(fromString: string, fontSize: fontSize, unit: unit, fontWeight: .regular, unitColor: nil)
    }

    public static func formattedString(fromString string: String, fontSize: Double, unit: String, fontWeight: Font.Weight) -> AttributedString {
        return formattedString(fromString: string, fontSize: fontSize, unit: unit, fontWeight: fontWeight, unitColor: nil)
    }
}
