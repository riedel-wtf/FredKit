//
//  File.swift
//  
//
//  Created by Frederik Riedel on 05.11.21.
//

import Foundation
import UIKit



public class FredKitProVersionBenefitsOverViewTableView: UITableView {
    
    var includedInProVersion: FredKitIncludedInProVersion? {
        didSet {
            self.dataSource = self
            self.delegate = self
            
            self.register(UINib(nibName: "FreeProComparisionTableViewCell", bundle: Bundle.module), forCellReuseIdentifier: "FreeProComparisionTableViewCell")
            
            self.reloadData()
        }
    }
    
}

extension FredKitProVersionBenefitsOverViewTableView: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return includedInProVersion?.freeVersionIncludes.count ?? 0
        }
        
        return includedInProVersion?.proVersionAlsoIncludes.count ?? 0
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeProComparisionTableViewCell", for: indexPath) as! FreeProComparisionTableViewCell
        
        if indexPath.section == 0 {
            cell.leftColumnTitleText = "Free"
            cell.rightColumnTitleText = "Pro"
            cell.benefitTitleText = ""
            cell.isFirstRow = true
        } else if indexPath.section == 1 {
            cell.benefitTitleText = includedInProVersion!.freeVersionIncludes[indexPath.row]
            cell.leftColumnIsAvailable = true
            cell.rightColumnIsAvailable = true
        } else if indexPath.section == 2 {
            cell.benefitTitleText = includedInProVersion!.proVersionAlsoIncludes[indexPath.row]
            cell.leftColumnIsAvailable = false
            cell.rightColumnIsAvailable = true
            
            if indexPath.row == includedInProVersion!.proVersionAlsoIncludes.count - 1 {
                cell.isLastRow = true
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46.0
    }
    
    
}
