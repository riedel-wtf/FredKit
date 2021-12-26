//
//  File.swift
//  
//
//  Created by Frederik Riedel on 25.11.21.
//

import Foundation

public struct FredKitContext {
    public static var isCurrentlyRunningUnitTests: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        #else
        return false
        #endif
    }
    
    public static var isDebugBuild: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    public static var isTestFlightBuild: Bool {
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            return false
        }
        return path.contains("sandboxReceipt")
    }
    
    public static var isAppStoreBuild: Bool {
        return !isTestFlightBuild && !isDebugBuild
    }
}
