//
//  FreeProComparisionTableViewCell.swift
//  FredKit Test App
//
//  Created by Frederik Riedel on 05.11.21.
//

import UIKit

class FreeProComparisionTableViewCell: UITableViewCell {

    @IBOutlet weak var benefitTitle: UILabel!
    @IBOutlet weak var leftColumnTitle: UILabel!
    @IBOutlet weak var rightColumnTitle: UILabel!
    @IBOutlet weak var leftColumnIcon: UIImageView!
    @IBOutlet weak var rightColumnIcon: UIImageView!
    @IBOutlet weak var secondColumnBackgroundView: UIView!
    
    
    
    var leftColumnTitleText: String? {
        didSet {
            leftColumnTitle.isHidden = false
            leftColumnIcon.isHidden = true
            leftColumnTitle.text = leftColumnTitleText
        }
    }
    
    var rightColumnTitleText: String? {
        didSet {
            rightColumnTitle.isHidden = false
            rightColumnIcon.isHidden = true
            rightColumnTitle.text = rightColumnTitleText
        }
    }
    
    var rightColumnIsAvailable: Bool = true {
        didSet {
            rightColumnIcon.image = rightColumnIsAvailable.icon
            rightColumnIcon.tintColor = rightColumnIsAvailable.color
        }
    }
    
    var leftColumnIsAvailable: Bool = true {
        didSet {
            leftColumnIcon.image = leftColumnIsAvailable.icon
            leftColumnIcon.tintColor = leftColumnIsAvailable.color
        }
    }
    
    var benefitTitleText: String? {
        didSet {
            benefitTitle.text = benefitTitleText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        leftColumnTitle.isHidden = true
        rightColumnTitle.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isFirstRow: Bool = false {
        didSet {
            if isFirstRow {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: secondColumnBackgroundView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
                self.secondColumnBackgroundView.layer.mask = maskLayer
            }
        }
    }
    
    var isLastRow: Bool = false {
        didSet {
            if isLastRow {
                if #available(iOS 11.0, *) {
                    secondColumnBackgroundView.clipsToBounds = true
                    secondColumnBackgroundView.layer.cornerRadius = 12
                    secondColumnBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
                }
                separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        leftColumnTitle.isHidden = true
        rightColumnTitle.isHidden = true
        isLastRow = false
        isFirstRow = false
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension Bool {
    var icon: UIImage? {
        if self {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "checkmark.circle.fill")
            }
        } else {
            if #available(iOS 13.0, *) {
                return UIImage(systemName: "xmark.circle")
            }
        }
        
        return nil
    }
    
    var color: UIColor {
        if self {
            return UIColor.systemGreen
        } else {
            return UIColor.systemRed
        }
    }
}
