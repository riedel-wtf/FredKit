//
//  FredKitTimeInterval.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/1/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation

public extension TimeInterval {
    static let nanosecond = TimeInterval.millisecond / 1000.0
    static let millisecond = TimeInterval.second / 1000.0
    static let second = 1.0
    static let minute = 60.0
    static let hour = 60.0 * TimeInterval.minute
    static let day = 24.0 * TimeInterval.hour
    static let week = 7.0 * TimeInterval.day
    static let month = 30.0 * TimeInterval.day
    static let year = 365.0 * TimeInterval.day
    static let decade = TimeInterval.year * 10.0
    static let century = TimeInterval.year * 100.0
    static let millenium = TimeInterval.year * 1000.0
}

public extension Date {
    
    var shortTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    func shortDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self)
    }
    
    var shortWeekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayInWeek = dateFormatter.string(from: self)
        return dayInWeek
    }
    
    var shortMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM '‘'yy"
        return dateFormatter.string(from: self)
    }
    
    var shortDate: String {
        let template = "MMM dd"
        let locale = NSLocale.current // the device current locale
        
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    var longDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: self)
    }
    
    var compactDateTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    var isInFuture: Bool {
        return self.timeIntervalSinceNow > 0
    }
}
