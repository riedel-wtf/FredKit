//
//  ProVersionTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 05.11.21.
//

import UIKit

@objc public class ProVersionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var proComparisionTableView: FredKitProVersionBenefitsOverViewTableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainRedeemButton: FredKitButton!
    
    @IBOutlet weak var renewalInfoLabel: UILabel!
    
    @IBOutlet weak var learnMoreButton: UIButton!
    
    @IBOutlet weak var redeemStackView: UIStackView!
    
    @IBOutlet weak var upgradeTitleLabel: UILabel!
    
    @IBOutlet weak var upgradeHeaderLabel: UILabel!
    
    public static var nib: UINib {
        UINib(nibName: "ProVersionTableViewCell", bundle: Bundle.module)
    }
    
    
    @IBAction func learnMore(_ sender: Any) {
        
        if let freeTrialProduct = FredKitSubscriptionManager.shared.cachedProducts.freeTrialProduct {
            mainRedeemButton.showLoading()
            FredKitSubscriptionManager.shared.purchaseSubscription(forProduct: freeTrialProduct) { success in
                self.mainRedeemButton.hideLoading()
            }
        } else {
            self.openUpgradeDetailView()
        }
    }
    
    
    @IBAction func smallLearnMoreButton(_ sender: Any) {
        self.openUpgradeDetailView()
    }
    
    private func openUpgradeDetailView() {
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
        
        upgradeHeaderLabel.text = "Upgrade now to \(FredKitSubscriptionManager.shared.proTitle!)".uppercased()
        
        let title = NSAttributedString(string: "Learn more", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.white
        ])
        
        self.mainRedeemButton.setAttributedTitle(title, for: .normal)
        self.renewalInfoLabel.isHidden = true
        self.learnMoreButton.isHidden = true
        
        FredKitSubscriptionManager.shared.waitForCachedProducts { products in
            
            if #available(iOS 11.2, *) {
                if let freeTrialProduct = products.freeTrialProduct {
                    if let freeTrialDuration = freeTrialProduct.introductoryPrice?.subscriptionPeriod.localizedDurationVerbose, let localizedPriceString = freeTrialProduct.localizedPrice {
                        
                        let title = NSAttributedString(string: "Redeem your free \(freeTrialDuration)", attributes: [
                            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                            .foregroundColor: UIColor.white
                        ])
                        
                        self.mainRedeemButton.setAttributedTitle(title, for: .normal)
                        
                        self.renewalInfoLabel.isHidden = false
                        self.learnMoreButton.isHidden = false
                        
                        self.renewalInfoLabel.text = "Then only \(localizedPriceString) every \(freeTrialProduct.subscriptionPeriod!.localizedDurationVerbose)."
                        
                        self.resizeToFitContent()
                    }
                }
            }
            
        }
        
        proComparisionTableView.includedInProVersion = FredKitSubscriptionManager.shared.includedInProVersion
        
        tableViewHeightConstraint.constant = CGFloat(FredKitSubscriptionManager.shared.includedInProVersion.count + 1) * 46
        // Initialization code
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


