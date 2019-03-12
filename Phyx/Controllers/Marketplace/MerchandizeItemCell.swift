//
//  MerchandizeItemCell.swift
//  Camp
//
//  Created by sonnaris on 8/24/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class MerchandizeItemCell: UICollectionViewCell {

    static let identifier = "MerchandizeItemCell"
    
    @IBOutlet weak var parentView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.parentView.layer.cornerRadius = 3
        let path = UIBezierPath(rect: self.parentView.bounds)
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = 2
        border.fillColor = UIColor.clear.cgColor
        self.parentView.layer.addSublayer(border)
    }

}

protocol MerchandizeItemDelegate: class {
    func merchandizeItemTapped(_ indexPath: IndexPath)
}
