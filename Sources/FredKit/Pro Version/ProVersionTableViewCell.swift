//
//  ProVersionTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 05.11.21.
//

import UIKit

public class ProVersionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var proComparisionTableView: FredKitProVersionBenefitsOverViewTableView!
    
    @IBOutlet weak var upgradeOptionsTableView: FredKitUpgradeOptionsTableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tryProButton: FredKitButton!
    
    public static var nib: UINib {
        UINib(nibName: "ProVersionTableViewCell", bundle: Bundle.module)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        let includedInProVersion = FredKitIncludedInProVersion(freeVersionIncludes: [
            "Apple Watch Tracking",
            "Basic Stats"
        ], proVersionAlsoIncludes: [
            "Unlimited Tracking",
            "Charts",
            "Long-Term Stats",
            "Import .fit and .gpx"
        ])
        
        FredKitSubscriptionManager.shared.waitForCachedProducts { products in
            self.upgradeOptionsTableView.availableProducts = products.withoutTips
        }

        
        proComparisionTableView.includedInProVersion = includedInProVersion
        
        tableViewHeightConstraint.constant = CGFloat(includedInProVersion.count + 1) * 46
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


