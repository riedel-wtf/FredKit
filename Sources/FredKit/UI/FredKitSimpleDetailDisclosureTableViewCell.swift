//
//  FredKitSimpleDetailDisclosureTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/7/21.
//

import UIKit

public class FredKitSimpleDetailDisclosureTableViewCell: UITableViewCell {

    @IBOutlet public weak var iconView: UIImageView!
    @IBOutlet public weak var title: UILabel!
    @IBOutlet public weak var backgroundColorView: UIView!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColorView.layer.cornerRadius = 8
        backgroundColorView.layer.masksToBounds = true
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColorView.isHidden = false
    }
    
}
