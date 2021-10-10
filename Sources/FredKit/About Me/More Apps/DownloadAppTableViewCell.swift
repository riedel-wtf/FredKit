//
//  DownloadAppTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/8/21.
//

import UIKit

class DownloadAppTableViewCell: UITableViewCell {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDescription: UILabel!
    @IBOutlet weak var appIconView: UIImageView!
    
    @IBOutlet weak var viewButton: UIButton!
    
    private var app: App?
    
    func updateContent(forApp app: App) {
        self.app = app
        self.appName.text = app.name
        self.appDescription.text = app.subtitle
        self.appIconView.image = app.icon
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewButton.layer.cornerRadius = 13
        viewButton.layer.masksToBounds = true
        
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold)]
        let attributedString = NSMutableAttributedString(string:"VIEW", attributes: attrs)
        viewButton.setAttributedTitle(attributedString, for: .normal)
        

    
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewOnAppStore(_ sender: Any) {
        if let app = self.app {
            let ituneUrl =  app.url
            UIApplication.shared.openURL(URL(string: ituneUrl)!)
        }
    }
    
}
