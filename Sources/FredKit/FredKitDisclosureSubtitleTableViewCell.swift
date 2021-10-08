//
//  FredKitDisclosureSubtitleTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/8/21.
//

import UIKit

class FredKitDisclosureSubtitleTableViewCell: UITableViewCell {

    @IBOutlet weak var largeTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func updateContents(cellDetails: DisclosureSubtitleCell) {
        self.largeTitleLabel.text = cellDetails.title
        self.subtitleLabel.text = cellDetails.subtitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
