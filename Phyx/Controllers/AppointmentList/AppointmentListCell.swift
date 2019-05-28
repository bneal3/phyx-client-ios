//
//  AppointmentListCell.swift
//  Phyx
//
//  Created by sonnaris on 9/3/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SwiftyAvatar

class AppointmentListCell: UITableViewCell {
    
    static let identifier = "AppointmentListCell"

    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var firstAddressLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
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
        nameView.text = dateFormatter.string(from: meetingTime)
        
        var number = ""
        if let digits = appointment.address.number {
            number = String(digits)
        }
        var zipCode = ""
        if let zip = appointment.address.areaCode {
            zipCode = String(zip)
        }
        firstAddressLabel.text = "\(number) \(appointment.address.street), \(appointment.address.city) \(appointment.address.state), \(zipCode)"
        
        serviceLabel.text = SERVICE_TITLES[appointment.service]
        if appointment.status >= 0 {
            statusLabel.text = APPOINTMENT_STATUS[appointment.status]
        } else {
            statusLabel.text = "Cancelled"
        }
    }
    
}
