//
//  FredKitUpgradeOptionCollectionViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 06.11.21.
//

import UIKit

class FredKitUpgradeOptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subscriptionDurationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.systemBlue.cgColor
        self.layer.borderWidth = 2
        // Initialization code
    }

}
