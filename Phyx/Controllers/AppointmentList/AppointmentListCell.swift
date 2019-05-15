//
//  NewConversationCell.swift
//  Camp
//
//  Created by sonnaris on 9/3/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SwiftyAvatar

class AppointmentListCell: UITableViewCell {
    
    static let identifier = "AppointmentListCell"

    @IBOutlet weak var avatar: SwiftyAvatar!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var firstAddressLabel: UILabel!
    @IBOutlet weak var secondAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(appointment: Appointment) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let meetingTime = Date(timeIntervalSince1970: appointment.meetingTime.toTimeInterval())
        print(meetingTime)
        nameView.text = dateFormatter.string(from: meetingTime)
        
        var number = ""
        if let digits = appointment.address.number {
            number = String(digits)
        }
        firstAddressLabel.text = "\(number) \(appointment.address.street)"
        var areaCode = ""
        if let zip = appointment.address.areaCode {
            areaCode = String(zip)
        }
        secondAddressLabel.text = "\(appointment.address.city) \(appointment.address.state) \(areaCode)"
    }
    
}
