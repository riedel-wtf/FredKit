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
        } else if -(self.timeIntervalSinceNow)/60/60/24 < 4 {
            // show weekday
            let formatterWeekday = DateFormatter()
            formatterWeekday.dateFormat = "EEEE"
            let weekday = formatterWeekday.string(from: self).firstCharacterCapitalized
            return weekday
        }
        
        // show date
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
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


