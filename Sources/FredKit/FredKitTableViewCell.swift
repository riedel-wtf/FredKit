//
//  File.swift
//  
//
//  Created by Frederik Riedel on 07.11.21.
//

import Foundation
import UIKit

public extension UITableViewCell {
    
    func resizeToFitContent() {
        if let tableView = self.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        } else if let tableView = self.superview?.superview as? UITableView {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }   
}
