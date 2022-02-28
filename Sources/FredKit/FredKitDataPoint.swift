//
//  FredKitDataPoint.swift
//  FredKit
//
//  Created by Frederik Riedel on 11/8/20.
//

import Foundation

public protocol FredKitJSONObject {
    init(withJson json: [String: Any])
    var json: [String: Any] { get }
}

@available(iOS 11.0, macOS 10.13, *)
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

public protocol FredKitJSONDataPoint: FredKitDataPoint, FredKitJSONObject {
    
}

public protocol AccumulationType {
    func accumulate(dataPoints: [FredKitDataPoint]) -> Double
    var rangeTitle: String { get }
}

public enum DefaultAccumulationType: AccumulationType {
    case min, max, sum, average, count
    
    public func accumulate(dataPoints: [FredKitDataPoint]) -> Double {
        switch self {
        case .min:
            return dataPoints.minimumValue
        case .max:
            return dataPoints.maximumValue
        case .sum:
            return dataPoints.sum
        case .average:
            return dataPoints.average
        case .count:
            return Double(dataPoints.count)
        }
    }
    
    public var rangeTitle: String {
        switch self {
        case .min:
            return FredKitLocalizedString(string: "MINIMUM IN RANGE", bundle: Bundle.module)
        case .max:
            return FredKitLocalizedString(string: "MAXIMUM IN RANGE", bundle: Bundle.module)
        case .sum:
            return FredKitLocalizedString(string: "TOTAL IN RANGE", bundle: Bundle.module)
        case .average:
            return FredKitLocalizedString(string: "AVERAGE IN RANGE", bundle: Bundle.module)
        case .count:
            return FredKitLocalizedString(string: "TOTAL # IN RANGE", bundle: Bundle.module)
        }
    }
}

public struct CustomAccumulationType: AccumulationType {
    
    public init(customAccumulationCallback: @escaping ([FredKitDataPoint]) -> Double, rangeTitle: String) {
        self.customAccumulationCallback = customAccumulationCallback
        self.rangeTitle = rangeTitle.uppercased()
    }
    
    let customAccumulationCallback: ([FredKitDataPoint]) -> Double
    public var rangeTitle: String
    
    
    public func accumulate(dataPoints: [FredKitDataPoint]) -> Double {
        return customAccumulationCallback(dataPoints)
    }
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
        if count == 0 {
            return 0.0
        }
        
        return sum / Double(count)
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
    
    @available(iOS 10.0, macOS 10.12, *)
    func filteredDataPoints(for dateInterval: DateInterval) -> [Element] {
        return self.filter({ (element) -> Bool in
            return element.timeStamp >= dateInterval.start && element.timeStamp <= dateInterval.end
        })
    }
    
    
    func accumulated(for accumulationType: AccumulationType) -> Double {
        return accumulationType.accumulate(dataPoints: self)
    }
    
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

public extension Array where Element: FredKitJSONDataPoint {
    var jsonArray: [ [String: Any] ] {
        return self.map { (dataPoint) -> [String: Any] in
            return dataPoint.json
        }
    }
}

public extension Array where Element == [ String: Any ] {
    
    func generateDataPointsArray<T: FredKitJSONDataPoint>() -> [T] {
        return self.compactMap { (json) -> T? in
            return T(withJson: json)
        }
    }
}
