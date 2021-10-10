//
//  MoreAppsTableViewController.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/8/21.
//

import UIKit



@available(iOS 13.0, *)
class MoreAppsTableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "More riedel.wtf Apps"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        let moreAppsNib = UINib(nibName: "DownloadAppTableViewCell", bundle: Bundle.module)
        tableView.register(moreAppsNib, forCellReuseIdentifier: "DownloadAppTableViewCell")
    }
    
    @objc func share() {
        let objectsToShare:URL = URL(string: "https://riedel.wtf")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FredKitApps.appsExcludingCurrentApp.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadAppTableViewCell", for: indexPath) as! DownloadAppTableViewCell
        
        let app = FredKitApps.appsExcludingCurrentApp[indexPath.row]
        cell.updateContent(forApp: app)
        
        return cell
    }
    
}
