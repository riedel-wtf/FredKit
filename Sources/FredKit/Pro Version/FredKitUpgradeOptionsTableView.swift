//
//  File.swift
//  
//
//  Created by Frederik Riedel on 06.11.21.
//

import Foundation
import UIKit
import StoreKit

class FredKitUpgradeOptionsTableView: UITableView {
    
    var availableProducts: [SKProduct] = [] {
        didSet {
            self.delegate = self
            self.register(UINib(nibName: "FredKitUpgradeOptionTableViewCell", bundle: Bundle.module), forCellReuseIdentifier: "FredKitUpgradeOptionTableViewCell")
            self.dataSource = self
            currentlySelectedIndexpath = IndexPath(row: 0, section: 0)
            previouslySelectedIndexPath = currentlySelectedIndexpath
            self.reloadData()
        }
    }
    
    var previouslySelectedIndexPath: IndexPath?
    var currentlySelectedIndexpath: IndexPath?
}

extension FredKitUpgradeOptionsTableView: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return availableProducts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitUpgradeOptionTableViewCell", for: indexPath) as! FredKitUpgradeOptionTableViewCell
        
        cell.product = availableProducts[indexPath.section]
        
        if let currentlySelectedIndexpath = self.currentlySelectedIndexpath {
            if currentlySelectedIndexpath == indexPath {
                cell.selectedByUser = true
            } else {
                cell.selectedByUser = false
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentlySelectedIndexpath = indexPath
        if let previouslySelectedIndexPath = self.previouslySelectedIndexPath {
            tableView.reloadRows(at: [
                previouslySelectedIndexPath, indexPath
            ], with: .automatic)
        } else {
            tableView.reloadRows(at: [
                indexPath
            ], with: .automatic)
        }
        previouslySelectedIndexPath = indexPath
        
    }
}
