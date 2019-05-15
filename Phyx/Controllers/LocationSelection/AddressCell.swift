//
//  NewConversationCell.swift
//  Camp
//
//  Created by sonnaris on 9/3/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import MapKit
import SwiftyAvatar

class AddressCell: UITableViewCell {
    
    static let identifier = "AddressCell"

    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAddress(address: MKMapItem) {
        //streetLabel.text = "\(address.number) \(address.street)"
        //streetLabel.text = "\(address.street) \(address.state), \(address.areaCode)"
        let addy = Address(address: address.placemark.title!)
        streetLabel.text = "\(addy.digits) \(addy.street)"
        var areaCode = ""
        if let zip = addy.areaCode {
            areaCode = String(zip)
        }
        cityLabel.text = "\(addy.city) \(addy.state) \(areaCode)"
    }
    
}
