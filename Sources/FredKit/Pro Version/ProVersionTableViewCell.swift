//
//  ProVersionTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 05.11.21.
//

import UIKit

public class ProVersionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var proComparisionTableView: FredKitProVersionBenefitsOverViewTableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var learnMoreButton: UIButton!
    
    @IBOutlet weak var renewalInfoLabel: UILabel!
    
    
    
    @IBOutlet weak var upgradeTitleLabel: UILabel!
    
    @IBOutlet weak var upgradeHeaderLabel: UILabel!
    
    public static var nib: UINib {
        UINib(nibName: "ProVersionTableViewCell", bundle: Bundle.module)
    }
    
    
    @IBAction func learnMore(_ sender: Any) {
        
        if #available(iOS 13.0, *) {
            let upgradeDetailVC = FredKitUpgradeDetailTableViewController(style: .insetGrouped)
            UIViewController.topViewController()?.present(upgradeDetailVC.wrappedInNavigationController, animated: true)
        } else {
            let upgradeDetailVC = FredKitUpgradeDetailTableViewController(style: .grouped)
            UIViewController.topViewController()?.present(upgradeDetailVC.wrappedInNavigationController, animated: true)
        }
        
        
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
        
        
        let title = NSAttributedString(string: "Learn more", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.white
        ])
        
        self.learnMoreButton.setAttributedTitle(title, for: .normal)
        self.renewalInfoLabel.isHidden = true
        
        FredKitSubscriptionManager.shared.waitForCachedProducts { products in
            
            if #available(iOS 11.2, *) {
                if let freeTrialProduct = products.freeTrialProduct {
                    if let freeTrialDuration = freeTrialProduct.introductoryPrice?.subscriptionPeriod.localizedDurationVerbose, let localizedPriceString = freeTrialProduct.localizedPrice {
                        
                        let title = NSAttributedString(string: "Redeem your free \(freeTrialDuration)", attributes: [
                            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                            .foregroundColor: UIColor.white
                        ])
                        
                        self.learnMoreButton.setAttributedTitle(title, for: .normal)
                        
                        self.renewalInfoLabel.isHidden = false
                        self.renewalInfoLabel.text = "Then only \(localizedPriceString) every \(freeTrialProduct.subscriptionPeriod!.localizedDurationVerbose)."
                        
                        self.resizeToFitContent()
                    }
                }
            }
            
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


