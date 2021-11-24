//
//  FredKitDate.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/1/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation

public extension Date {
    
    var humanReadableDateString: String {
        let calendar = NSCalendar.current
        
        if calendar.isDateInToday(self) {
            // show today
            return NSLocalizedString("Today", comment: "")
        } else if calendar.isDateInYesterday(self) {
            // yesterday
            return NSLocalizedString("Yesterday", comment: "")
        } else if self.isInCurrentWeek {
            // show weekday
            let formatterWeekday = DateFormatter()
            formatterWeekday.dateFormat = "EEEE"
            let weekday = formatterWeekday.string(from: self).firstCharacterCapitalized
            return weekday
        }
        
        // show date
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
    }
    
    var isInCurrentWeek: Bool {
        var startDate = Date()
        var interval : TimeInterval = 0.0
        let calendar = Calendar.current
        let _ = calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: Date())
        let endDate = calendar.date(byAdding:.second, value: Int(interval), to: startDate)!
        return self >= startDate && self < endDate
    }
    
    var humanReadableDateAndTimeString: String {
        let formattedTime = DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
        return "\(humanReadableDateString), \(formattedTime)"
    }
    
    var shortTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    var minuteTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
    
    var shortDateString: String {
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
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var shortDayOfMonth: String {
        let template = "dd"
        let locale = NSLocale.current // the device current locale
        
        let format = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
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
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var midOfMonth: Date {
        var components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        components.day = 15
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var nextDay: Date {
        let calendar = NSCalendar.current
        var dayFutureComponents = DateComponents()
        dayFutureComponents.day = 1 // aka 1 day
        
        return calendar.date(byAdding: dayFutureComponents, to: self)!
    }
}


