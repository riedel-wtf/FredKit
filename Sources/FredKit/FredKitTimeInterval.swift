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
    static let minute = 60.0 * TimeInterval.second
    static let hour = 60.0 * TimeInterval.minute
    static let day = 24.0 * TimeInterval.hour
    static let week = 7.0 * TimeInterval.day
    static let month = 30.0 * TimeInterval.day
    static let year = 365.0 * TimeInterval.day
    static let decade = TimeInterval.year * 10.0
    static let century = TimeInterval.year * 100.0
    static let millenium = TimeInterval.year * 1000.0
}
