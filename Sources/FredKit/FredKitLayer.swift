//
//  FredKitLayer.swift
//  FredKit
//
//  Created by Frederik Riedel on 1/23/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
#if canImport(QuartzCore)
import QuartzCore

#if !os(watchOS)
public extension CALayer {
    func setContinousCorner(radius: CGFloat) {
        self.cornerRadius = radius
        self.masksToBounds = true
        if #available(iOS 13.0, *), #available(macOS 10.15, *) {
            self.cornerCurve = .continuous
        }
    }
}
#endif
#endif
