//
//  FredKitDataPoint.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/8/20.
//

import Foundation
#if canImport(Charts)
import Charts
#endif

protocol FredKitJSONObject {
    init(withJson json: [String: Any])
    var json: [String: Any] { get }
}

@available(iOS 11.0, *)
extension FredKitJSONObject {
    init?(withFileURL url: URL) {
        if url.pathExtension == "plist" {
            if let data = NSDictionary(contentsOf: url) {
                if let json = data as? [String: Any] {
                    self.init(withJson: json)
                    return
                }
            }
        }
        
        return nil
    }
    
    func save(toFileURL url: URL) {
        
        let dict = NSDictionary(dictionary: self.json)
        dict.verifyContentsForSaving()
        
        do {
            try dict.write(to: url)
        } catch {
            print("could not save file: \(error)")
        }
    }
}

extension Array where Element: FredKitJSONObject {
    var json: [ [String: Any] ] {
        return self.map { (dataPoint) -> [String: Any] in
            return dataPoint.json
        }
    }
}

public protocol FredKitDataPoint {
    var value: Double { get }
    var timeStamp: Date { get set }
    static func localizedValue(for value: Double) -> String
}

public class FredKitSimpleDataPoint: FredKitDataPoint {
    
    public init(value: Double, timeStamp: Date) {
        self.value = value
        self.timeStamp = timeStamp
    }
    
    public var value: Double
    
    public var timeStamp: Date
    
    public static func localizedValue(for value: Double) -> String {
        return "\(value)"
    }
}

protocol FredKitJSONDataPoint: FredKitDataPoint, FredKitJSONObject {
    
}

public enum AccumulationType {
    case min, max, sum, average, count
}

public extension Array where Element == FredKitDataPoint {
    var averageValue: Double {
        return self.map { (dataPoint) -> Double in
            return dataPoint.value
        }.average
    }
    
    var maximumValue: Double {
        return self.map { (dataPoint) -> Double in
            return dataPoint.value
        }.max() ?? 0.0
    }
    
    var minimumValue: Double {
        return self.map { (dataPoint) -> Double in
            return dataPoint.value
        }.min() ?? 0.0
    }
    
    var sum: Double {
        return self.reduce(0) { partialResult, dataPoint in
            return partialResult + dataPoint.value
        }
    }
    
    var average: Double {
        sum / Double(count)
    }
    
    var maximumDatapoint: Element? {
        
        if let first = self.first {
            return self.reduce(first) { (result, nextDataPoint) -> Element in
                if nextDataPoint.value > result.value {
                    return nextDataPoint
                }
                return result
            }
        }

        return nil
    }
    
    var startDate: Date {
        self.min { dp1, dp2 in
            return dp1.timeStamp < dp2.timeStamp
        }?.timeStamp ?? Date()
    }
    
    var endDate: Date {
        self.max { dp1, dp2 in
            return dp1.timeStamp < dp2.timeStamp
        }?.timeStamp ?? Date()
    }
    
    func interpolatedDatapoint(forTimeStamp timeStamp: Date) -> Element? {
        if self.isEmpty {
            return nil
        }
        if timeStamp < self.first!.timeStamp {
            return self.first!
        }
        if timeStamp > self.last!.timeStamp {
            return self.last!
        }
        
        return self.reduce(self.first!) { (result, dataPoint) -> Element in
            if abs(timeStamp.timeIntervalSince(result.timeStamp)) > abs(timeStamp.timeIntervalSince(dataPoint.timeStamp)) {
                return dataPoint
            }
            return result
        }
    }
    
    func interpolatedValue(forTimeStamp timeStamp: Date) -> Double {
        return interpolatedDatapoint(forTimeStamp: timeStamp)?.value ?? 0
    }
    
    mutating func replaceDataPoints(inRange startDate: Date, endDate: Date, withDataPoints dataPoints: [Element]) {
        let prefix = self.filter { (dataPoint) -> Bool in
            return dataPoint.timeStamp < startDate
        }
        
        let suffix = self.filter { (dataPoint) -> Bool in
            return dataPoint.timeStamp >= endDate
        }
        
        self = prefix + dataPoints + suffix
    }
    
    func filteredDataPoints(forTimeFrame from: Date, to: Date) -> [Element] {
        return self.filter({ (element) -> Bool in
            return element.timeStamp >= from && element.timeStamp <= to
        })
    }
    
    func segmentedDataPoints(for timeIntervalConfiguration: ChartTimeIntervalConfiguration) -> [ Date: [Element] ] {
        
        let segmentIntervals = timeIntervalConfiguration.segmentIntervals
        
        var segmentedDataPoints = [Date: [Element]]()
        
        segmentIntervals.forEach { interval in
            segmentedDataPoints[interval.0] = self.filteredDataPoints(forTimeFrame: interval.0, to: interval.1)
        }
        
        return segmentedDataPoints
    }
    
    func accumulate(for timeIntervalConfiguration: ChartTimeIntervalConfiguration, accumulationType: AccumulationType) -> [FredKitDataPoint] {
        
        let segmentedDataPoints = self.segmentedDataPoints(for: timeIntervalConfiguration)
        
        return segmentedDataPoints.keys.map { keyDate in
            
            var value = 0.1
            
            if let dataPointsForSegment = segmentedDataPoints[keyDate] {
                switch accumulationType {
                case .min:
                    value = dataPointsForSegment.minimumValue
                case .max:
                    value = dataPointsForSegment.maximumValue
                case .sum:
                    value = dataPointsForSegment.sum
                case .average:
                    value = dataPointsForSegment.average
                case .count:
                    value = Double(dataPointsForSegment.count)
                }
            }
            
            return FredKitSimpleDataPoint(value: value, timeStamp: keyDate)
            
            
        }.sorted { dp1, dp2 in
            return dp1.timeStamp < dp2.timeStamp
        }
    }
    
    
    var dayliOccurances: [OccuranceDataPoint] {
        
        if let startTimeStamp = self.first?.timeStamp.startOfDay {
            let endOfToday = Date().endOfDay
            var day = startTimeStamp
            
            var dayliOccurancesDataPoints = [OccuranceDataPoint]()
            
            while  day < endOfToday {
                
                let dataPointsForThatDay = self.filter { (dataPoint) -> Bool in
                    return dataPoint.timeStamp > day && dataPoint.timeStamp < day.endOfDay
                }
                
                let occuranceDP = OccuranceDataPoint(value: Double(dataPointsForThatDay.count), timeStamp: day)
                dayliOccurancesDataPoints.append(occuranceDP)
                
                day = day.nextDay
            }
            
            return dayliOccurancesDataPoints
        }
        
        return []
    }
    
    var dayliMaxima: [Element] {
        if let startTimeStamp = self.first?.timeStamp.startOfDay {
            let endOfToday = Date().endOfDay
            var day = startTimeStamp
            
            var dayliMaximaDataPoints = [Element]()
            
            while  day < endOfToday {
                
                let dataPointsForThatDay = self.filter { (dataPoint) -> Bool in
                    return dataPoint.timeStamp > day && dataPoint.timeStamp < day.endOfDay
                }
                
                if var maximumDP = dataPointsForThatDay.maximumDatapoint {
                    maximumDP.timeStamp = day
                    dayliMaximaDataPoints.append(maximumDP)
                }
                
                
                day = day.nextDay
            }
            
            return dayliMaximaDataPoints
        }
        
        return []
    }
    
    #if canImport(Charts)
    var barChartDataEntries: [BarChartDataEntry] {
        return self.map { (dataPoint) -> BarChartDataEntry in
            return BarChartDataEntry(x: dataPoint.timeStamp.timeIntervalSince1970, y: dataPoint.value)
        }
    }
    
    var chartDataEntries: [ChartDataEntry] {
        return self.map { (dataPoint) -> ChartDataEntry in
            return ChartDataEntry(x: dataPoint.timeStamp.timeIntervalSince1970, y: dataPoint.value)
        }
    }
    #endif
}

public struct OccuranceDataPoint: FredKitDataPoint {
    
    public static func localizedValue(for value: Double) -> String {
        return "\(Int(value))×"
    }
    
    public var value: Double
    public var timeStamp: Date
}

extension Array where Element == Double {
    var average: Double {
        
        if self.count == 0 {
            return 0.0
        }
        
        return self.reduce(0.0) { (sum, value) -> Double in
            return sum + value
        } / Double(self.count)
    }
}


extension NSDictionary {
    func verifyContentsForSaving() {
        NSDictionary.verifyContentsForSaving(contents: self)
    }
    
    private static func verifyContentsForSaving(contents: Any) {
        
        if let dictionary = contents as? NSDictionary {
            dictionary.keyEnumerator().forEach { (key) in
                
                if key is String {
                    if let object = dictionary.object(forKey: key) {
                        NSDictionary.verifyContentsForSaving(contents: object)
                    }
                } else {
                    print("Problem: Key is not String: \(key)")
                }
                
            }
        } else if let array = contents as? NSArray {
            array.forEach { (element) in
                NSDictionary.verifyContentsForSaving(contents: element)
            }
        } else if let _ = contents as? NSData {
            
        } else if let _ = contents as? NSDate {
            
        } else if let _ = contents as? NSNumber {
            
        } else if let _ = contents as? NSString {
            
        } else {
            print("found a weird object that I cannot save: \(contents)")
        }
    }
}
