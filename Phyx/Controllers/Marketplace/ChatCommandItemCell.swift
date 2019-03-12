//
//  ChatCommandItemCell.swift
//  Camp
//
//  Created by sonnaris on 8/24/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class ChatCommandItemCell: UICollectionViewCell {
    
    static let identifier = "ChatCommandItemCell"
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var coinView: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var iconView: UIImageView!
    
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
        
        self.indicatorView.layer.cornerRadius = 5
        
    }

}

protocol ChatItemDelegate: class {
    
    func chatItemTapped(_ indexPath: IndexPath)
    
}
