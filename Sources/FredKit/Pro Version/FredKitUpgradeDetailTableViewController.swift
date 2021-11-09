//
//  FredKitUpgradeDetailTableViewController.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 07.11.21.
//

import UIKit
import StoreKit

@objc public class FredKitUpgradeDetailTableViewController: UITableViewController {
        
    @objc public static func show() {
        let detailVC = FredKitUpgradeDetailTableViewController.insetGroupedStyle.wrappedInNavigationController
        detailVC.modalPresentationStyle = .formSheet
        UIViewController.topViewController()?.present(detailVC, animated: true)
    }
    
    @objc public static var insetGroupedStyle: FredKitUpgradeDetailTableViewController {
        if #available(iOS 13.0, *) {
            return FredKitUpgradeDetailTableViewController(style: .insetGrouped)
        } else {
            return FredKitUpgradeDetailTableViewController(style: .grouped)
        }
    }
    
    var previouslySelectedIndexPath: IndexPath?
    var currentlySelectedIndexpath: IndexPath?
    
    var availableProducts: [SKProduct] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didChangeSubscriptionStatus),
            name: NSNotification.Name(rawValue: "upgradedToPro"),
            object: nil
        )

        self.title = FredKitSubscriptionManager.shared.proTitle
        
        self.tableView.register(UINib(nibName: "FredKitUpgradeOptionTableViewCell", bundle: Bundle.module), forCellReuseIdentifier: "FredKitUpgradeOptionTableViewCell")
        
        self.tableView.register(UINib(nibName: "ProVersionTableViewCell", bundle: Bundle.module), forCellReuseIdentifier: "ProVersionTableViewCell")
        
        FredKitSubscriptionManager.shared.waitForCachedProducts { products in
            self.availableProducts = products.filterForSubscriptionProducts + products.filterForLifeTimeUnlockProducts
            
            self.currentlySelectedIndexpath = IndexPath(row: 0, section: 1)
            self.previouslySelectedIndexPath = self.currentlySelectedIndexpath
            
            self.tableView.reloadData()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Maybe later", style: .plain, target: self, action: #selector(close))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restore))
        
    }
    
    @objc func didChangeSubscriptionStatus() {
        print("Did Change Subscription Status: \(FredKitSubscriptionManager.shared.isCurrentlySubscribed)")
        
        #if DEBUG
        let upgradeSuccessfulVC = UpgradeSuccessfulViewController(nibName: "UpgradeSuccessfulViewController", bundle: Bundle.module)
        self.navigationController?.pushViewController(upgradeSuccessfulVC, animated: true)
        #else
        if FredKitSubscriptionManager.shared.isCurrentlySubscribed {
            let upgradeSuccessfulVC = UpgradeSuccessfulViewController(nibName: "UpgradeSuccessfulViewController", bundle: Bundle.module)
            self.navigationController?.pushViewController(upgradeSuccessfulVC, animated: true)
        }
        #endif
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    @objc func restore() {
        FredKitSubscriptionManager.shared.restorePurchases { result in
            
        }
    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + availableProducts.count
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProVersionTableViewCell", for: indexPath) as! ProVersionTableViewCell

            cell.redeemStackView.isHidden = true 
            cell.upgradeTitleLabel.isHidden = true
            cell.upgradeHeaderLabel.isHidden = true
        
            return cell
        }
        
        let index = indexPath.section - 1
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitUpgradeOptionTableViewCell", for: indexPath) as! FredKitUpgradeOptionTableViewCell

        let product = availableProducts[index]
        cell.product = product
        
        if let currentlySelectedIndexpath = self.currentlySelectedIndexpath {
            if currentlySelectedIndexpath == indexPath {
                cell.selectedByUser = true
            } else {
                cell.selectedByUser = false
            }
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentlySelectedIndexpath = indexPath
        if let previouslySelectedIndexPath = self.previouslySelectedIndexPath {
            tableView.reloadRows(at: [
                previouslySelectedIndexPath, currentlySelectedIndexpath!
            ], with: .automatic)
        } else {
            tableView.reloadRows(at: [
                currentlySelectedIndexpath!
            ], with: .automatic)
        }
        previouslySelectedIndexPath = indexPath
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6.0
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6.0
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    
}
