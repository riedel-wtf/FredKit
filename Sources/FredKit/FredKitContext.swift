//
//  File.swift
//  
//
//  Created by Frederik Riedel on 25.11.21.
//

import Foundation

public struct FredKitContext {
    static var isCurrentlyRunningUnitTests: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        #else
        return false
        #endif
    }
}
