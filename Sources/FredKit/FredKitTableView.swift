//
//  FredKitView.swift
//  FredKit
//
//  Created by Frederik Riedel on 1/24/19.
//  Copyright © 2019 Frederik Riedel. All rights reserved.
//

#if !os(watchOS)
import Foundation
import UIKit

public extension UITableView {
    func registerMainBundleNibs(withNames names: [String]) {
        names.forEach { (nibName) in
            self.register(UINib(nibName: nibName, bundle: Bundle.main), forCellReuseIdentifier: nibName)
        }
    }
}
#endif
