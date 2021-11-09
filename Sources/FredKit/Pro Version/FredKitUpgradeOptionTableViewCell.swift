//
//  FredKitUpgradeOptionTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 06.11.21.
//

import UIKit
import StoreKit

class FredKitUpgradeOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var annotationView: UIView!
    @IBOutlet weak var annotationViewLabel: UILabel!
    
    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var priceInfoLabel: UILabel!
    @IBOutlet weak var moreDetailInfosLabel: UILabel!
    
    @IBOutlet weak var startButton: FredKitButton!
    
    @IBOutlet weak var selectionCheckmark: UIImageView!
    
    
    var product: SKProduct? {
        didSet {
            if let product = product {
                
                
                var attributedString = NSAttributedString(string: "Start Now", attributes: [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
                ])
                
                if #available(iOS 14.0, *) {
                    if product.isFamilyShareable {
                        moreDetailInfosLabel.isHidden = false
                        moreDetailInfosLabel.text = "You can share this plan with up to 5 family members via iCloud Family Sharing."
                    } else {
                        moreDetailInfosLabel.isHidden = true
                    }
                } else {
                    moreDetailInfosLabel.isHidden = true
                }
                
                if #available(iOS 11.2, *) {
                    if let subscriptionPeriod = product.subscriptionPeriod {
                        if subscriptionPeriod.unit == .year {
                            planTitleLabel.text = "Pro Plan (Annual)"
                        } else if subscriptionPeriod.unit == .month {
                            planTitleLabel.text = "Pro Plan (Monthly)"
                        }
                        
                        if product.hasFreeTrial {
                            annotationView.isHidden = false
                            annotationViewLabel.text = "Free Trial"
                            priceInfoLabel.text = "First month is free, then \(product.localizedPrice!) per \(subscriptionPeriod.localizedDurationVerbose)."
                        } else {
                            annotationView.isHidden = true
                            priceInfoLabel.text = "\(product.localizedPrice!) per \(subscriptionPeriod.localizedDurationVerbose)."
                        }
                        
                        if let monthlyPrice = product.breakDownMonthlyPrice {
                            priceInfoLabel.text! += " That‘s only \(monthlyPrice) per month!"
                        }
                        
                    } else {
                        planTitleLabel.text = "Pro Plan (Lifetime Unlock)"
                        annotationView.isHidden = true
                        attributedString = NSAttributedString(string: "Activate", attributes: [
                            .foregroundColor: UIColor.white,
                            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
                        ])
                        priceInfoLabel.text = "One-time payment of \(product.localizedPrice!)."
                    }
                }
                
                startButton.setAttributedTitle(attributedString, for: .normal)
            }
        }
    }
    
    @IBOutlet weak var purchaseProductButton: FredKitButton!
    
    @IBAction func purchaseProduct(_ sender: Any) {
        print("User selected product: \(product!.localizedTitle)")
        purchaseProductButton.showLoading()
        FredKitSubscriptionManager.shared.purchaseSubscription(forProduct: product!) { success in
            self.purchaseProductButton.hideLoading()
            print("Purchase successfull: \(self.product!.localizedTitle)")
        }
    }
    
    
    var selectedByUser: Bool = false {
        didSet {
            if selectedByUser {
                if #available(iOS 13.0, *) {
                    selectionCheckmark.image = UIImage(systemName: "checkmark.circle.fill")
                    selectionCheckmark.tintColor = .systemBlue
                    startButton.isHidden = false
                    self.layer.borderWidth = 2
                    self.layer.borderColor = UIColor.systemBlue.cgColor
                }
            } else {
                if #available(iOS 13.0, *) {
                    selectionCheckmark.image = UIImage(systemName: "circle")
                    selectionCheckmark.tintColor = .secondaryLabel
                    startButton.isHidden = true
                    self.layer.borderWidth = 0
                }
            }
            
            self.resizeToFitContent()
            if #available(iOS 13.0, *) {
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false) { _ in
                    self.resizeToFitContent()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        annotationView.clipsToBounds = true
        annotationView.layer.cornerRadius = 6
        if #available(iOS 11.0, *) {
            annotationView.layer.maskedCorners = [.layerMinXMaxYCorner]
        }
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
