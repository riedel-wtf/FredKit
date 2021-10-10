//
//  FredKitAppInfoTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/9/21.
//

import UIKit

class FredKitAppInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var versionInfoLabel: UILabel!
    @IBOutlet weak var appIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appNameLabel.text = UIApplication.shared.appName
        appIconImageView.image = UIApplication.shared.appIcon
        appIconImageView.layer.cornerRadius = 8
        appIconImageView.layer.masksToBounds = true
        
        versionInfoLabel.text = """
Version \(UIApplication.shared.versionString)
Build \(UIApplication.shared.buildNumber)
"""
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
