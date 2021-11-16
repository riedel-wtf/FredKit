//
//  FredKitView.swift
//  FredKit
//
//  Created by Frederik Riedel on 1/24/19.
//  Copyright © 2019 Frederik Riedel. All rights reserved.
//

#if os(iOS)
import Foundation
import UIKit

public extension UIViewController {
    var wrappedInNavigationController: UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    static func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}
#endif
