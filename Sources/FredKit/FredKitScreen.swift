//
//  File.swift
//  FredKit
//
//  Created by Frederik Riedel on 16.09.24.
//

#if os(iOS)
import Foundation
import UIKit

public extension UIScreen {
    static var isSuperSmallScreen: Bool {
        if UIScreen.main.bounds.height <= 568 {
            return true
        }
        return false
    }
    
    static var isKindaSmallScreen: Bool {
        if UIScreen.main.bounds.height < 700 {
            return true
        }
        return false
    }
}
#endif
