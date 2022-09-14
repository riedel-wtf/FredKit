//
//  FredKitTimeInterval.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/1/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import StoreKit


public extension TimeInterval {
    static let nanosecond = TimeInterval.millisecond / 1000.0
    static let millisecond = TimeInterval.second / 1000.0
    static let second = 1.0
    static let minute = 60.0 * TimeInterval.second
    static let hour = 60.0 * TimeInterval.minute
    static let day = 24.0 * TimeInterval.hour
    static let week = 7.0 * TimeInterval.day
    static let month = 30.0 * TimeInterval.day
    static let year = 365.0 * TimeInterval.day
    static let decade = TimeInterval.year * 10.0
    static let century = TimeInterval.year * 100.0
    static let millenium = TimeInterval.year * 1000.0
    
#if os(iOS)
    var localizedValue: LocalizedValue {
        let availableTimeIntervalOptions = [TimeInterval.year, .month, .week, .day, .hour, .minute, .second, .millisecond, .nanosecond]
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        
        let biggestTimeIntervalOption = availableTimeIntervalOptions.first { timeIntervalOption in
            return self >= timeIntervalOption
        }
        
        guard let biggestTimeIntervalOption = biggestTimeIntervalOption else {
            return LocalizedValue(value: "0", unit: "s")
        }
        
        let amountOfTimeinterval = NSNumber(value: self / biggestTimeIntervalOption)
        
        if amountOfTimeinterval.doubleValue >= 5 || amountOfTimeinterval.doubleValue == Double(amountOfTimeinterval.intValue) || self < .second || self > .day {
            return LocalizedValue(value: numberFormatter.string(from: amountOfTimeinterval)!, unit: self.localizedUnitForTimeInterval)
        } else {
            let fullAmountOfTimeIntervalOption = amountOfTimeinterval.intValue
            let representedTimeInterval = (Double(fullAmountOfTimeIntervalOption) * biggestTimeIntervalOption)
            return LocalizedValue(value: "\(fullAmountOfTimeIntervalOption)", unit: representedTimeInterval.localizedUnitForTimeInterval)
        }
    }
#endif
    
    var humanReadableTimeInterval: String {
        if self < 3 * TimeInterval.day && self > TimeInterval.second {
            return self.simpleTimeIntervalString
        }
        
        return self.humanReadableTimeInterval(fillRemainingTimeWithSmallerUnitsIfFeasable: false)
    }
    
    func veryShortHumanReadableTimeInterval(leadingZeros: Bool) -> String {
        if Int(self) % Int(TimeInterval.day) == 0 {
            return self.humanReadableTimeInterval(fillRemainingTimeWithSmallerUnitsIfFeasable: false)
        }
        
        var timeIntervalInSeconds = Int(self)
        let numberOfHours = Int(Double(timeIntervalInSeconds) / TimeInterval.hour)
        timeIntervalInSeconds -= numberOfHours * Int(TimeInterval.hour)
        let numberOfMinutes = Int(Double(timeIntervalInSeconds) / TimeInterval.minute)
        timeIntervalInSeconds -= numberOfMinutes * Int(TimeInterval.minute)
        let numberOfSeconds = Int(timeIntervalInSeconds)
        
        if numberOfHours == 0 && numberOfMinutes == 0 {
            return String(format: "%ds", numberOfSeconds)
        }
        
        if numberOfHours == 0 && numberOfSeconds == 0 {
            return String(format: "%d min", numberOfMinutes)
        }
        
        if leadingZeros {
            if numberOfHours == 0 {
                return String(format: "%0.2d min", numberOfMinutes)
            }
            
            return String(format: "%0.2d \(FredKitLocalizedString(string: "hrs", bundle: Bundle.module))", numberOfHours)
        }
        
        if numberOfHours == 0 {
            return String(format: "%d min", numberOfMinutes)
        }
        
        return String(format: "%d \(FredKitLocalizedString(string: "hrs", bundle: Bundle.module))", numberOfHours)
    }
    
    private var localizedUnitForTimeInterval: String {
        if self > .year {
            return FredKitLocalizedString(string: "years", bundle: Bundle.module)
        } else if self == .year {
            return FredKitLocalizedString(string: "year", bundle: Bundle.module)
        } else if self > .month {
            return FredKitLocalizedString(string: "months", bundle: Bundle.module)
        } else if self == .month {
            return FredKitLocalizedString(string: "month", bundle: Bundle.module)
        } else if self > .week {
            return FredKitLocalizedString(string: "weeks", bundle: Bundle.module)
        } else if self == .week {
            return FredKitLocalizedString(string: "week", bundle: Bundle.module)
        } else if self > .day {
            return FredKitLocalizedString(string: "days", bundle: Bundle.module)
        } else if self == .day {
            return FredKitLocalizedString(string: "day", bundle: Bundle.module)
        } else if self > .hour {
            return FredKitLocalizedString(string: "hrs", bundle: Bundle.module)
        } else if self == .hour {
            return FredKitLocalizedString(string: "hr", bundle: Bundle.module)
        } else if self > .minute {
            return FredKitLocalizedString(string: "mins", bundle: Bundle.module)
        } else if self == .minute {
            return FredKitLocalizedString(string: "min", bundle: Bundle.module)
        } else if self > .second {
            return FredKitLocalizedString(string: "s", bundle: Bundle.module)
        } else if self == .second {
            return FredKitLocalizedString(string: "s", bundle: Bundle.module)
        } else if self >= .millisecond {
            return FredKitLocalizedString(string: "ms", bundle: Bundle.module)
        } else if self >= .nanosecond {
            return FredKitLocalizedString(string: "ns", bundle: Bundle.module)
        }
        
        return ""
    }
    
    private var simpleTimeIntervalString: String {
        
        if Int(self) % Int(TimeInterval.day) == 0 {
            return self.humanReadableTimeInterval(fillRemainingTimeWithSmallerUnitsIfFeasable: false)
        }
        
        var timeIntervalInSeconds = Int(self)
        let numberOfHours = Int(Double(timeIntervalInSeconds) / TimeInterval.hour)
        timeIntervalInSeconds -= numberOfHours * Int(TimeInterval.hour)
        let numberOfMinutes = Int(Double(timeIntervalInSeconds) / TimeInterval.minute)
        timeIntervalInSeconds -= numberOfMinutes * Int(TimeInterval.minute)
        let numberOfSeconds = Int(timeIntervalInSeconds)
        
        if numberOfHours == 0 && numberOfMinutes == 0 {
            return String(format: "%ds", numberOfSeconds)
        }
        
        if numberOfHours == 0 && numberOfSeconds == 0 {
            return String(format: "%d min", numberOfMinutes)
        }
        
        if numberOfHours == 0 {
            return String(format: "%0.2d:%0.2d min", numberOfMinutes, numberOfSeconds)
        }
        
        if numberOfSeconds == 0 {
            return String(format: "%0.2d:%0.2d \(FredKitLocalizedString(string: "hrs", bundle: Bundle.module))",numberOfHours,numberOfMinutes)
        }
        return String(format: "%0.2d:%0.2d:%0.2d \(FredKitLocalizedString(string: "hrs", bundle: Bundle.module))",numberOfHours,numberOfMinutes,numberOfSeconds)
    }
    
    private func humanReadableTimeInterval(fillRemainingTimeWithSmallerUnitsIfFeasable: Bool) -> String {
        let availableTimeIntervalOptions = [TimeInterval.year, .month, .week, .day, .hour, .minute, .second, .millisecond, .nanosecond]
        
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        
        let biggestTimeIntervalOption = availableTimeIntervalOptions.first { timeIntervalOption in
            return self >= timeIntervalOption
        }
        
        guard let biggestTimeIntervalOption = biggestTimeIntervalOption else {
            return "0s"
        }
        
        let amountOfTimeinterval = NSNumber(value: self / biggestTimeIntervalOption)
        
        if amountOfTimeinterval.doubleValue >= 5 || amountOfTimeinterval.doubleValue == Double(amountOfTimeinterval.intValue) || self < .second || !fillRemainingTimeWithSmallerUnitsIfFeasable {
            return "\(numberFormatter.string(from: amountOfTimeinterval)!) \(self.localizedUnitForTimeInterval)"
        } else {
            let fullAmountOfTimeIntervalOption = amountOfTimeinterval.intValue
            let representedTimeInterval = (Double(fullAmountOfTimeIntervalOption) * biggestTimeIntervalOption)
            var timeIntervalString = "\(fullAmountOfTimeIntervalOption) \(representedTimeInterval.localizedUnitForTimeInterval)"
            let remainingTimeInterval = self - representedTimeInterval
            if fillRemainingTimeWithSmallerUnitsIfFeasable {
                timeIntervalString = "\(timeIntervalString), \(remainingTimeInterval.humanReadableTimeInterval(fillRemainingTimeWithSmallerUnitsIfFeasable: false))"
            }
            
            return timeIntervalString
        }
    }
}
