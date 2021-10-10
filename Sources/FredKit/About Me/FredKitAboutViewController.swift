//
//  FredKitAboutViewController.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/7/21.
//

import Foundation
import UIKit
import SafariServices
import StoreKit

public struct WebLinkCell {
    public init(title: String, url: String, icon: UIImage?) {
        self.title = title
        self.url = url
        self.icon = icon
    }
    
    let title: String
    let url: String
    let icon: UIImage?
}

public struct InAppPurchaseCell {
    public init(title: String, subtitle: String, productID: String) {
        self.title = title
        self.subtitle = subtitle
        self.productID = productID
    }
    
    let title: String
    let subtitle: String
    let productID: String
}


private struct TableSections {
    static let Header = 0,
         AppInfos = 1,
         MarketingLinks = 2,
        AdditionalAppLinks = 3,
         Tips = 4,
         Legal = 5,
         count = 6
}

public class FredKitAboutViewController: UITableViewController {

    
    let firstSectionLinks = [
        WebLinkCell(title: "Website", url: "https://riedel.wtf", icon: UIImage(named: "link", in: Bundle.module, compatibleWith: nil)),
        WebLinkCell(title: "Twitter", url: "https://twitter.com/frederikRiedel", icon: UIImage(named: "twitter", in: Bundle.module, compatibleWith: nil)),
        WebLinkCell(title: "Newsletter", url: "https://frederikriedel.typeform.com/to/tq4XnMcA?typeform-source=app-about", icon: UIImage(named: "newsletter", in: Bundle.module, compatibleWith: nil)),
        WebLinkCell(title: "Support", url: "https://riedel.wtf/support/", icon: UIImage(named: "support", in: Bundle.module, compatibleWith: nil))
    ]
    
    let secondSectionLinks = [
        WebLinkCell(title: "Terms & Conditions, Privacy Policy", url: "https://riedel.wtf/privacy", icon: UIImage(named: "paragraph", in: Bundle.module, compatibleWith: nil)),
        WebLinkCell(title: "Imprint", url: "https://riedel.wtf/imprint", icon: UIImage(named: "paragraph", in: Bundle.module, compatibleWith: nil))
    ]
    
    public var additionalAppLinks = [WebLinkCell]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    public var inAppPurchaseCells = [InAppPurchaseCell]() {
        didSet {
            let productIds = inAppPurchaseCells.map { inAppCell in
                inAppCell.productID
            }
            
            FredKitSubscriptionManager.setup(productIds: productIds, delegate: self)
        }
    }
    
    public static var defaultNavigationController: UINavigationController  {
        return self.defaultViewController.wrappedInNavigationController
    }
    
    public static var defaultViewController: FredKitAboutViewController  {
        if #available(iOS 13.0, *) {
            return FredKitAboutViewController(style: .insetGrouped)
        } else {
            return FredKitAboutViewController(style: .grouped)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "About"
        
        let nib = UINib(nibName: "FredKitSimpleDetailDisclosureTableViewCell", bundle: Bundle.module)
        tableView.register(nib, forCellReuseIdentifier: "FredKitSimpleDetailDisclosureTableViewCell")
        
        
        let nibRiedelWtf = UINib(nibName: "FredKitAboutMeTableViewCell", bundle: Bundle.module)
        tableView.register(nibRiedelWtf, forCellReuseIdentifier: "FredKitAboutMeTableViewCell")
        
        
        let subtitleCellNib = UINib(nibName: "FredKitInAppPurchaseTableViewCell", bundle: Bundle.module)
        tableView.register(subtitleCellNib, forCellReuseIdentifier: "FredKitInAppPurchaseTableViewCell")
        
        let riedelWtfHeaderNib = UINib(nibName: "FredKitAboutHeaderTableViewCell", bundle: Bundle.module)
        tableView.register(riedelWtfHeaderNib, forCellReuseIdentifier: "FredKitAboutHeaderTableViewCell")
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let appInfosNib = UINib(nibName: "FredKitAppInfoTableViewCell", bundle: Bundle.module)
        tableView.register(appInfosNib, forCellReuseIdentifier: "FredKitAppInfoTableViewCell")
        
        if #available(iOS 13.0, *) {
            
            if let navigationController = self.navigationController {
                if navigationController.isBeingPresented {
                    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
                    self.navigationItem.rightBarButtonItem = done
                }
            }
        }
    }
    
    @objc func done() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Table view data source
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return TableSections.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TableSections.Header {
            return 2
        }
        
        if section == TableSections.MarketingLinks {
            return firstSectionLinks.count
        }
        
        if section == TableSections.Tips {
            return inAppPurchaseCells.count
        }
        
        if section == TableSections.Legal {
            return secondSectionLinks.count
        }
        
        if section == TableSections.AppInfos {
            return 2
        }
        
        if section == TableSections.AdditionalAppLinks {
            return additionalAppLinks.count
        }
        
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == TableSections.Header {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitAboutHeaderTableViewCell") as! FredKitAboutHeaderTableViewCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = "More riedel.wtf apps"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            
        }
        
        
        
        if indexPath.section == TableSections.AppInfos {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitAppInfoTableViewCell") as! FredKitAppInfoTableViewCell
                
                return cell
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = "Share \(UIApplication.shared.appName)"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            
        }
        
        if indexPath.section == TableSections.Tips {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitInAppPurchaseTableViewCell") as! FredKitInAppPurchaseTableViewCell
            cell.subtitleLabel.isHidden = false
            let detailCell = inAppPurchaseCells[indexPath.row]
            cell.updateContents(cellDetails: detailCell)
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitSimpleDetailDisclosureTableViewCell") as! FredKitSimpleDetailDisclosureTableViewCell
        
        if indexPath.section == TableSections.AdditionalAppLinks {
            let webLinkCell = additionalAppLinks[indexPath.row]
            cell.iconView.image = webLinkCell.icon
            cell.title.text = webLinkCell.title
        }
        
        if indexPath.section == TableSections.MarketingLinks {
            let webLinkCell = firstSectionLinks[indexPath.row]
            cell.iconView.image = webLinkCell.icon
            cell.title.text = webLinkCell.title
        }
        
        
        
        if indexPath.section == TableSections.Legal {
            let webLinkCell = secondSectionLinks[indexPath.row]
            cell.iconView.image = webLinkCell.icon
            cell.title.text = webLinkCell.title
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == TableSections.Tips {
            return UITableView.automaticDimension
        }
        
        if indexPath.section == TableSections.AppInfos {
            return UITableView.automaticDimension
        }
        
        if indexPath.section == TableSections.Header {
            if indexPath.row == 0 {
                return 200
            }
            return 55
        }
        
        return UITableView.automaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        
        return UITableView.automaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        
        return UITableView.automaticDimension
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == TableSections.Header && indexPath.row == 1 {
            if #available(iOS 13.0, *) {
                let moreAppsVC = MoreAppsTableViewController(style: .insetGrouped)
                self.navigationController?.pushViewController(moreAppsVC, animated: true)
            }
        }
        
        if indexPath.section == TableSections.MarketingLinks {
            let webLinkCell = firstSectionLinks[indexPath.row]
            let safariVC = SFSafariViewController(url: URL(string: webLinkCell.url)!)
            self.present(safariVC, animated: true)
        }
        
        if indexPath.section == TableSections.AdditionalAppLinks {
            let webLinkCell = additionalAppLinks[indexPath.row]
            let safariVC = SFSafariViewController(url: URL(string: webLinkCell.url)!)
            self.present(safariVC, animated: true)
        }
        
        if indexPath.section == TableSections.Tips {
            let inAppPurchaseCell = inAppPurchaseCells[indexPath.row]
            if let product = FredKitSubscriptionManager.shared.product(forId: inAppPurchaseCell.productID) {
                FredKitSubscriptionManager.shared.purchaseSubscription(forProduct: product) { success in
                    if success {
                        tableView.reloadData()
                        let thankYouAlert = UIAlertController(title: "Thank you ❤️", message: "Your support is very much appreciated!", preferredStyle: .alert)
                        
                        let continueButton = UIAlertAction(title: "Continue", style: .default)
                        
                        thankYouAlert.addAction(continueButton)
                        
                        self.present(thankYouAlert, animated: true)
                        
                    } else {
                        tableView.reloadData()
                    }
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if indexPath.section == TableSections.Legal {
            let webLinkCell = secondSectionLinks[indexPath.row]
            let safariVC = SFSafariViewController(url: URL(string: webLinkCell.url)!)
            self.present(safariVC, animated: true)
        }
        
        if indexPath.section == TableSections.AppInfos && indexPath.row == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            if #available(iOS 13.0, *) {
                if let appStoreUrl = UIApplication.shared.appStoreUrl {
                    let sharedObjects:[AnyObject] = [appStoreUrl as AnyObject]
                    let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
                    activityViewController.popoverPresentationController?.sourceView = self.view
                    
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension FredKitAboutViewController: FredKitSubscriptionManagerDelegate {
    public func didFinishFetchingProducts(products: [SKProduct]) {
        self.tableView.reloadData()
    }
}
