//
//  UnitConverter.swift
//  Boulder Buddy
//
//  Created by Frederik Riedel on 1/22/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit

public struct LocalizedValue: Equatable, Hashable, Codable {

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



public enum UnitSystem: String, Equatable, Hashable, Codable {
    case metric, imperial
}

@available(iOS 10.0, *)
public struct LocalizedUnitConverter {
    
    public static let sharedConverter = LocalizedUnitConverter()
    
    let metricUnits = [UnitLength.centimeters, UnitLength.meters, UnitLength.kilometers]
    let imperialUnits = [UnitLength.inches, UnitLength.feet, UnitLength.yards, UnitLength.miles]

    /// When no specific `unitSystem` is specified, the device's preferred system is used
    public func convertValue(_ value: Double, from unit: UnitLength, to preferredUnitSystem: UnitSystem? = nil, numberOfFractionDigits: Int = 2) -> LocalizedValue {
        let fmt = NumberFormatter()
        fmt.maximumFractionDigits = numberOfFractionDigits
        fmt.minimumFractionDigits = 0
        fmt.minimumIntegerDigits = 1
        fmt.usesGroupingSeparator = true
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.numberFormatter = fmt
        measurementFormatter.unitOptions = .providedUnit

        var measurement = Measurement(value: value, unit: unit)
        if let preferredUnitSystem {
            measurement = measurement.naturalMeasurement(in: preferredUnitSystem)
        }

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

    public func convertToLocalizedUnit(value: Double, from unit: UnitLength, numberOfFractionDigits: Int = 2) -> LocalizedValue {
        self.convertValue(value, from: unit, to: nil, numberOfFractionDigits: numberOfFractionDigits)
    }
    
    public static func convertToLocalizedNumber(number: Int, numberOfDigits: Int) -> String {
        convertToLocalizedNumber(number: Double(number), numberOfDigits: numberOfDigits)
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
        switch unitSystem {
        case .metric:
            let measurementInMeters = abs(converted(to: .meters).value)
            return if measurementInMeters <= 0.01 {
                .meters
            } else if measurementInMeters < 1.0 {
                .centimeters
            } else if measurementInMeters > 999.0 {
                .kilometers
            } else {
                .meters
            }
        case .imperial:
            let measurementInFeet = abs(converted(to: .feet).value)
            return if measurementInFeet <= 0.01 {
                .feet
            } else if measurementInFeet < 1.0 {
                .inches
            } else if measurementInFeet > 999.0 && measurementInFeet < 3000.0 {
                .yards
            } else if measurementInFeet >= 3000.0 {
                .miles
            } else {
                .feet
            }
        }
    }
    
    public func naturalMeasurement(in unitSystem: UnitSystem) -> Measurement {
        return converted(to: naturalScale(in: unitSystem))
    }
}


@available(iOS 10.0, *)
public extension Double {
    var localizedUnitFromMeters: LocalizedValue {
        return LocalizedUnitConverter.sharedConverter.convertToLocalizedUnit(value: self, from: .meters)
    }
}

#endif
