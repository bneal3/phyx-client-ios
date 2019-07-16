//
//  Appointment.swift
//  Phyx
//
//  Created by Benjamin Neal on 3/21/19.
//  Copyright © 2019 Phyx, Inc. All rights reserved.
//

import Foundation
import RealmSwift

var APPOINTMENT_STATUS = [
    "Requested",
    "Accepted",
    "En Route",
    "Session",
    "Completed"
]

enum APPOINTMENT_SERVICES: Int {
    case Chiropractic = 0
    case Reiki
    case Swedish
    case Tissue
    case Sports
    case Pregnancy
    case Reflexology
    case Couples
    case Acupuncture
    case PhysicalTherapy
}

var SERVICE_TITLES = [
    "Chiropractic",
    "Reiki",
    "Swedish Massage",
    "Tissue Massage",
    "Sports Massage",
    "Pregnancy Massage",
    "Refloxology Massage",
    "Couples Massage",
    "Acupuncture",
    "Physical Therapy"
]

var MASSAGE_LENGTHS: [Int] = [
    30,
    60,
    90,
    120
]

// API Appointment Model
@objcMembers class Appointment: Object {
    
    dynamic var id: String = ""
    dynamic var userId: String = ""
    dynamic var contractorId: String? = ""
    dynamic var service: Int = 0
    dynamic var meetingTime: Int64 = 0
    dynamic var status: Int = 0
    dynamic var location: String = ""
    var length: Int? = -1
    var rating: Int? = -1
    dynamic var notes: String? = ""
    dynamic var cost: Float = -1
    
    var startTime: Int64? = 0
    var endTime: Int64? = 0
    
    dynamic var creationTime: Int64 = 0
    
    var address: Address {
        get {
            return Address(address: location)
        }
    }
    
    convenience init(appointmentData: [String: Any]){
        self.init()
        
        if let id = appointmentData["_id"] as? String {
            self.id = id
        }
        
        if let userId = appointmentData["userId"] as? String {
            self.userId = userId
        }
        
        if let contractorId = appointmentData["contractorId"] as? String, contractorId != "" {
            self.contractorId = contractorId
        }
        
        if let service = appointmentData["service"] as? Int {
            self.service = service
        }
        
        if let meetingTime = appointmentData["meetingTime"] as? Int64 {
            self.meetingTime = meetingTime
        }
        
        if let status = appointmentData["status"] as? Int {
            self.status = status
        }
        
        if let location = appointmentData["location"] as? String {
            self.location = location
        }
        
        if let length = appointmentData["length"] as? Int, length > 0 {
            self.length = length
        }
        
        if let ratingData = appointmentData["rating"] as? [String: Any] {
            if let client = ratingData["user"] as? Int, client != -1 {}
            if let contractor = ratingData["contractor"] as? Int, contractor != -1 {
                self.rating = contractor
            }
        }
        
        if let notes = appointmentData["notes"] as? String, notes != "" {
            self.notes = notes
        }
        
        if let cost = appointmentData["cost"] as? Float {
            self.cost = cost
        }
        
        if let session = appointmentData["session"] as? [String: Any] {
            if let startTime = session["startTime"] as? Int64 {
                self.startTime = startTime
            }
            if let endTime = session["endTime"] as? Int64 {
                self.endTime = endTime
            }
        }
        
        if let creationTime = appointmentData["creationTime"] as? Int64 {
            self.creationTime = creationTime
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
