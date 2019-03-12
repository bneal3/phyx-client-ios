//
//  MarketplaceItem.swift
//  Camp
//
//  Created by sonnaris on 8/24/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class MarketplaceItem: UICollectionViewCell {
    
    static let identifier = "MarketplaceItem"
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var chatImageView: UIImageView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.parentView.layer.cornerRadius = 3
    
        parentView.layer.cornerRadius = 3
        
        let path = UIBezierPath(rect: self.parentView.bounds)
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = 2
        border.fillColor = UIColor.clear.cgColor
        self.parentView.layer.addSublayer(border)
        
        self.indicatorView.layer.cornerRadius = 5
    
        //self.imageView.kf.setImage(with: URL(string: "https://thumb.ibb.co/chkGLK/uber_rebrand_designcrowd_contest_dezeen_1568_13.jpg"))
    }
    
    
    public func configureCell(type: Bool) {
        if type {
            
            self.chatView.isHidden = false
            self.imageView.isHidden = true
        } else {
            self.chatView.isHidden = true
            self.imageView.isHidden = false
            
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.stackView.layer.cornerRadius = 3
        let stackPath = UIBezierPath(roundedRect: self.stackView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 3.0, height: 3.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.stackView.bounds
        maskLayer.path = stackPath.cgPath
        self.stackView.layer.mask = maskLayer
        
        self.chatView.layer.cornerRadius = 3
        let chatPath = UIBezierPath(roundedRect: self.chatView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 3.0, height: 3.0))
        maskLayer.frame = self.chatView.bounds
        maskLayer.path = chatPath.cgPath
        self.chatView.layer.mask = maskLayer
        
        self.imageView.layer.cornerRadius = 3
        let imagePath = UIBezierPath(roundedRect: self.imageView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 3.0, height: 3.0))
        maskLayer.frame = self.imageView.bounds
        maskLayer.path = imagePath.cgPath
        self.imageView.layer.mask = maskLayer

    }

}
