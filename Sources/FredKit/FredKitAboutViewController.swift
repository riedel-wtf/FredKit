//
//  FredKitAboutViewController.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/7/21.
//

import Foundation
import UIKit
import SafariServices

struct WebLinkCell {
    let title: String
    let url: String
    let icon: UIImage?
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
        
        if #available(iOS 13.0, *) {
            if self.navigationController!.isBeingPresented {
                let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
                self.navigationItem.rightBarButtonItem = done
            }
        }
    }
    
    @objc func done() {
        self.dismiss(animated: true)
    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return firstSectionLinks.count
        }
        
        if section == 2 {
            return secondSectionLinks.count
        }
        
        return 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitAboutMeTableViewCell") as! FredKitAboutMeTableViewCell
            
            return cell
        }
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FredKitSimpleDetailDisclosureTableViewCell") as! FredKitSimpleDetailDisclosureTableViewCell
        
        if indexPath.section == 1 {
            let webLinkCell = firstSectionLinks[indexPath.row]
            cell.iconView.image = webLinkCell.icon
            cell.title.text = webLinkCell.title
        }
        
        if indexPath.section == 2 {
            let webLinkCell = secondSectionLinks[indexPath.row]
            cell.iconView.image = webLinkCell.icon
            cell.title.text = webLinkCell.title
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 133
        }
        
        return 55
    }
    
    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return "\(UIApplication.shared.appName) Version \(UIApplication.shared.humanReadableVersionString)"
        }
        return nil
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if indexPath.section == 1 {
            let webLinkCell = firstSectionLinks[indexPath.row]
            let safariVC = SFSafariViewController(url: URL(string: webLinkCell.url)!)
            self.present(safariVC, animated: true)
        }
        
        if indexPath.section == 2 {
            let webLinkCell = secondSectionLinks[indexPath.row]
            let safariVC = SFSafariViewController(url: URL(string: webLinkCell.url)!)
            self.present(safariVC, animated: true)
        }
    }
    
}
