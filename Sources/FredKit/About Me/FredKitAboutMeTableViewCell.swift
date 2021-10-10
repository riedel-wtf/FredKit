//
//  FredKitAboutMeTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/7/21.
//

import UIKit

class FredKitAboutMeTableViewCell: UITableViewCell {

    @IBOutlet weak var riedelWtfLogoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        riedelWtfLogoView.layer.cornerRadius = riedelWtfLogoView.frame.width / 2
        riedelWtfLogoView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        riedelWtfLogoView.layer.cornerRadius = riedelWtfLogoView.frame.width / 2
    }
    
}
