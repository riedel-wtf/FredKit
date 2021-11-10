//
//  FredKitLocalizedString.swift
//  FredKit
//
//  Created by Frederik Riedel on 12/7/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation

public func NSLocalizedString(_ key: String) -> String {
    
    let localizedValue = NSLocalizedString(key, comment: "")
    if localizedValue == "" {
        return key
    }
    return localizedValue
}

public func FredKitLocalizedString(string: String, bundle: Bundle, args: CVarArg...) -> String {
    let localizedString = NSLocalizedString(string, bundle: bundle, comment: "")
    
    let localizedFormattedString = String(format: localizedString, arguments: args)
    
    return localizedFormattedString
}
