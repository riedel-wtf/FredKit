//
//  FredKitAboutHeaderTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/9/21.
//

import UIKit

class FredKitAboutHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var riedelWtfTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        riedelWtfTitle.font = riedelWtfTitle.font.rounded
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
