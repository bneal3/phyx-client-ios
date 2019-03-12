//
//  NewConversationCell.swift
//  Camp
//
//  Created by sonnaris on 9/3/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SwiftyAvatar

class NewConversationCell: UITableViewCell {
    
    static let identifier = "NewConversationCell"

    @IBOutlet weak var avatar: SwiftyAvatar!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
