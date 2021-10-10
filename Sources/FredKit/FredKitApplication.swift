//
//  FredKitApplication.swift
//  
//
//  Created by Frederik Riedel on 11/8/20.
//

import Foundation
import UIKit

public extension UIApplication {
    var humanReadableVersionString: String {
        return "\(versionString) build \(buildNumber)"
    }
    
    var buildNumber: String {
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as! String
        return build
    }
    
    var versionString: String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
    
    var appName: String {
        let dictionary = Bundle.main.infoDictionary!
        let appName = dictionary["CFBundleName"] as! String
        return appName
    }
    
    var appIcon: UIImage? {
        let dictionary = Bundle.main.infoDictionary!
        if let bundleIcons = dictionary["CFBundleIcons"] as? [String: Any],
           let primaryIcons = bundleIcons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcons["CFBundleIconFiles"] as? Array<String>,
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
    
    var bundleID: String {
        let bundleID = Bundle.main.bundleIdentifier!
        return bundleID
    }
    
    @available(iOS 13.0, *)
    var appStoreUrl: URL? {
        if let currentApp = FredKitApps.app(for: UIApplication.shared.bundleID) {
            return URL(string: currentApp.url)
        }
        
        if bundleID == "wtf.riedel.FredKit-Test-App" {
            return URL(string: "https://test-app.riedel.wtf")
        }
        
        return nil
    }
    
}
