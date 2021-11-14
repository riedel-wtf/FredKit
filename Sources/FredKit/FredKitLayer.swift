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

public extension CALayer {
    func setContinousCorner(radius: CGFloat) {
        self.cornerRadius = radius
        self.masksToBounds = true
        if #available(iOS 13.0, *) {
            self.cornerCurve = .continuous
        }
    }
}
#endif
