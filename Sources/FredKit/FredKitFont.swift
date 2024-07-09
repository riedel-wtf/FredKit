//
//  FredKitFont.swift
//  FredKit
//
//  Created by Frederik Riedel on 6/14/19.
//  Copyright © 2019 Frederik Riedel. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    // Returns the rounded version of the font, if available.
    var rounded: UIFont {
        if #available(iOS 13.0, *), #available(watchOS 5.2, *), #available(watchOSApplicationExtension 5.2, *) {
            if let roundedDescriptor = fontDescriptor.withDesign(.rounded) {
                return UIFont(descriptor: roundedDescriptor, size: pointSize)
            }
        }
        return self
    }
}
