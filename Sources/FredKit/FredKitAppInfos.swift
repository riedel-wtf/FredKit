//
//  FredKitApplication.swift
//  
//
//  Created by Frederik Riedel on 11/8/20.
//

import Foundation
#if os(iOS)
import UIKit
#endif

public struct AppInfos {
    
    public static var humanReadableVersionString: String {
        return "\(versionString) build \(buildNumber)"
    }
    
    public static var buildNumber: String {
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as! String
        return build
    }
    
    public static var versionString: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
    
    public static var appName: String {
        let dictionary = Bundle.main.infoDictionary!
        let appName = dictionary["CFBundleName"] as! String
        return appName
    }
    
    #if os(iOS)
    public static var appIcon: UIImage? {
        let dictionary = Bundle.main.infoDictionary!
        if let bundleIcons = dictionary["CFBundleIcons"] as? [String: Any],
           let primaryIcons = bundleIcons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcons["CFBundleIconFiles"] as? Array<String>,
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    #endif
    
    public static var bundleID: String {
        let bundleID = Bundle.main.bundleIdentifier!
        return bundleID
    }
}

