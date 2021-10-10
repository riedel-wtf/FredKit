//
//  FredKitInAppPurchaseTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 10/8/21.
//

import UIKit

class FredKitInAppPurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var largeTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func updateContents(cellDetails: InAppPurchaseCell) {
        
        if let product = FredKitSubscriptionManager.shared.product(forId: cellDetails.productID) {
            self.largeTitleLabel.text = "\(cellDetails.title) \(product.localizedPriceString!)"
        } else {
            self.largeTitleLabel.text = cellDetails.title
        }
        
        
        self.subtitleLabel.text = cellDetails.subtitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            stackView.alpha = 0
            activityIndicator.alpha = 1
        }
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        activityIndicator.alpha = 0
        stackView.alpha = 1
    }
    
}
