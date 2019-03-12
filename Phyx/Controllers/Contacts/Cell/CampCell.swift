//
//  ContactCell.swift
//  Camp
//
//  Created by sonnaris on 8/20/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SwiftyAvatar

class CampCell: UITableViewCell {
    
    static let identifier = "CampCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatar: SwiftyAvatar!
    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        parentView.backgroundColor = UIColor.white
        parentView.layer.cornerRadius = 3
                
        let path = UIBezierPath(rect: self.parentView.bounds)
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = 2
        border.fillColor = UIColor.clear.cgColor
        self.parentView.layer.addSublayer(border)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setCell(service: Service) {
        nameLabel.text = service.name
        avatar.image = UIImage(named: service.photo)
    }
    
}
