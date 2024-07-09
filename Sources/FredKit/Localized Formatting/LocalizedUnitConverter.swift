//
//  UnitConverter.swift
//  Boulder Buddy
//
//  Created by Frederik Riedel on 1/22/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import UIKit

public struct LocalizedValue {
    
    public init(value: String, unit: String) {
        self.value = value
        self.unit = unit
    }
    
    public var value: String
    public var unit: String
    
    public func attributedString(ofSize fontSize: Double, weight: UIFont.Weight) -> NSAttributedString {
        return StringUnitFormatter.formattedString(fromString: value, fontSize: fontSize, unit: unit, fontWeight: weight)
    }
}


public enum UnitSystem: String {
    case metric, imperial
}

@available(iOS 10.0, *)
public struct LocalizedUnitConverter {
    
    public static let sharedConverter = LocalizedUnitConverter()
    
    let metricUnits = [UnitLength.centimeters, UnitLength.meters, UnitLength.kilometers]
    let imperialUnits = [UnitLength.inches, UnitLength.feet, UnitLength.yards, UnitLength.miles]
    
    public func convertToLocalizedUnit(value: Double, from unit: UnitLength, numberOfFractionDigits: Int = 2) -> LocalizedValue {
        let fmt = NumberFormatter()
        fmt.maximumFractionDigits = numberOfFractionDigits
        fmt.minimumFractionDigits = 0
        fmt.minimumIntegerDigits = 1
        fmt.usesGroupingSeparator = true
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = fmt
        measurementFormatter.unitOptions = .providedUnit
        
        let measurement = Measurement(value: value, unit: unit)
        
        let formattedMeasurement = measurementFormatter.string(from: measurement)
        if (formattedMeasurement.split(separator: " ").count > 1) {
            let resultingValue = formattedMeasurement.split(separator: " ")[0]
            let resultingUnit = formattedMeasurement.split(separator: " ")[1]
            
            return LocalizedValue(value: String(resultingValue), unit: String(resultingUnit))
        } else if (formattedMeasurement.split(separator: " ").count > 1) {
            let resultingValue = formattedMeasurement.split(separator: " ")[0]
            let resultingUnit = formattedMeasurement.split(separator: " ")[1]
            
            return LocalizedValue(value: String(resultingValue), unit: String(resultingUnit))
        }
        
        return LocalizedValue(value: formattedMeasurement, unit: "")
        
    }
    
    public static func convertToLocalizedNumber(number: Int, numberOfDigits: Int) -> String {
        return convertToLocalizedNumber(number: Double(number), numberOfDigits: numberOfDigits)
    }
    
    public static func convertToLocalizedNumber(number: Double, numberOfDigits: Int) -> String {
        let fmt = NumberFormatter()
        fmt.maximumFractionDigits = numberOfDigits
        fmt.minimumFractionDigits = 0
        fmt.minimumIntegerDigits = 1
        fmt.usesGroupingSeparator = true
        if let result = fmt.string(from: NSNumber(value: number)) {
            return result
        }
        return "--"
    }
}

@available(iOS 10.0, *)
extension Measurement where UnitType==UnitLength {
    public func naturalScale(in unitSystem: UnitSystem) -> UnitLength {
        if unitSystem == .imperial {
            
            let measurementInFeet = abs(converted(to: UnitLength.feet).value)
            
            if measurementInFeet < 1 {
                return .inches
            } else if measurementInFeet > 999 && measurementInFeet < 3000 {
                return .yards
            } else if measurementInFeet >= 3000 {
                return .miles
            }
            
            return .feet
        }
        
        let measurementInMeters = abs(converted(to: UnitLength.meters).value)

        if measurementInMeters < 1 {
            return .centimeters
        } else if measurementInMeters > 999 {
            return .kilometers
        }
        return .meters
    }
    
    public func natrualMeasurement(in unitSystem: UnitSystem) -> Measurement {
        return converted(to: naturalScale(in: unitSystem))
    }
}


@available(iOS 10.0, *)
public extension Double {
    var localizedUnitFromMeters: LocalizedValue {
        return LocalizedUnitConverter.sharedConverter.convertToLocalizedUnit(value: self, from: .meters)
    }
}
