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
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "\(version) build \(buildNumber)"
    }
    
    var buildNumber: String {
        let dictionary = Bundle.main.infoDictionary!
        let build = dictionary["CFBundleVersion"] as! String
        return build
    }
}
