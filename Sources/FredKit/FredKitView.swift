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

public extension UIView {
    var snapshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
#endif
