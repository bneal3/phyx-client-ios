//
//  UserData.swift
//  Phyx
//
//  Created by sonnaris on 8/22/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import OneSignal
import RealmSwift

class AppointmentData {
    
    private static var sharedData: AppointmentData = {
        let data = AppointmentData()
        return data
    }()
    
    class func shared() -> AppointmentData {
        return sharedData
    }
    
    // APPOINTMENT
    
    // Set
    public func setAppointment(appointment: Appointment) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(appointment.id, forKey: "appointment_id")
        userDefaults.set(appointment.userId, forKey: "appointment_userId")
        if let contractorId = appointment.contractorId {
            userDefaults.set(contractorId, forKey: "appointment_contractorId")
        }
        userDefaults.set(appointment.service, forKey: "appointment_service")
        if let length = appointment.length {
            userDefaults.set(length, forKey: "appointment_length")
        }
        
        userDefaults.set(appointment.meetingTime, forKey: "appointment_meetingTime")
        userDefaults.set(appointment.status, forKey: "appointment_status")
        userDefaults.set(appointment.location, forKey: "appointment_location")
        
        if let startTime = appointment.startTime {
            userDefaults.set(startTime, forKey: "appointment_startTime")
        }
        if let endTime = appointment.endTime {
            userDefaults.set(endTime, forKey: "appointment_endTime")
        }
        
        if let notes = appointment.notes {
            userDefaults.set(notes, forKey: "appointment_notes")
        }
        userDefaults.synchronize()
    }
    
    public func setUserId(userId: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(userId, forKey: "appointment_userId")
        userDefaults.synchronize()
    }
    
    public func setContractorId(contractorId: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(contractorId, forKey: "appointment_contractorId")
        userDefaults.synchronize()
    }
    
    public func setService(service: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(service, forKey: "appointment_service")
        userDefaults.synchronize()
    }
    
    public func setMeetingTime(meetingTime: Int64) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(meetingTime, forKey: "appointment_meetingTime")
        userDefaults.synchronize()
    }
    
    public func setStatus(status: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(status, forKey: "appointment_status")
        userDefaults.synchronize()
    }
    
    public func setLocation(location: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(location, forKey: "appointment_location")
        userDefaults.synchronize()
    }
    
    public func setLength(length: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(length, forKey: "appointment_length")
        userDefaults.synchronize()
    }
    
    public func setStartTime(startTime: Int64) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(startTime, forKey: "appointment_startTime")
        userDefaults.synchronize()
    }
    
    public func setEndTime(endTime: Int64) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(endTime, forKey: "appointment_endTime")
        userDefaults.synchronize()
    }
    
    public func setNotes(notes: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(notes, forKey: "appointment_notes")
        userDefaults.synchronize()
    }
    
    // Get
    public func getAppointment() -> Appointment {
        var appointmentData: [String: Any] = [:]
        
        let userDefaults = UserDefaults.standard
        
        let id = userDefaults.object(forKey: "appointment_id")
        appointmentData["_id"] = id
        
        let userId = userDefaults.object(forKey: "appointment_userId")
        appointmentData["userId"] = userId
        
        if let contractorId = userDefaults.object(forKey: "appointment_contractorId") as? String {
            appointmentData["contractId"] = contractorId
        }
        
        let service = userDefaults.object(forKey: "appointment_service")
        appointmentData["service"] = service
        
        let meetingTime = userDefaults.object(forKey: "appointment_meetingTime")
        appointmentData["meetingTime"] = meetingTime
        
        let status = userDefaults.object(forKey: "appointment_status")
        appointmentData["status"] = status
        
        let location = userDefaults.object(forKey: "appointment_location")
        appointmentData["location"] = location
        
        let length = userDefaults.object(forKey: "appointment_length")
        appointmentData["length"] = length
        
        let startTime = userDefaults.object(forKey: "appointment_startTime")
        appointmentData["startTime"] = startTime
        
        let endTime = userDefaults.object(forKey: "appointment_endTime")
        appointmentData["endTime"] = endTime
        
        if let notes = userDefaults.object(forKey: "appointment_notes") as? String {
            appointmentData["notes"] = notes
        }
        
        let appointment = Appointment(appointmentData: appointmentData)
        return appointment
    }
    
    public func getId() -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_id") as! String
    }
    
    public func getUserId() -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_userId") as! String
    }
    
    public func getContractorId() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_contractorId") as? String
    }
    
    public func getService() -> Int {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_service") as! Int
    }
    
    public func getMeetingTime() -> Int64 {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_meetingTime") as! Int64
    }
    
    public func getStatus() -> Int? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_status") as? Int
    }
    
    public func getLocation() -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_location") as! String
    }
    
    public func getLength() -> Int? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_length") as? Int
    }
    
    public func getStartTime() -> Int64? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_startTime") as? Int64
    }
    
    public func getEndTime() -> Int64? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_endTime") as? Int64
    }
    
    public func getNotes() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "appointment_notes") as? String
    }
    
    // Clear
    public func clear() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "appointment_id")
        userDefaults.removeObject(forKey: "appointment_userId")
        userDefaults.removeObject(forKey: "appointment_contractorId")
        userDefaults.removeObject(forKey: "appointment_service")
        
        userDefaults.removeObject(forKey: "appointment_meetingTime")
        userDefaults.removeObject(forKey: "appointment_status")
        userDefaults.removeObject(forKey: "appointment_location")
        userDefaults.removeObject(forKey: "appointment_length")
        
        userDefaults.removeObject(forKey: "appointment_startTime")
        userDefaults.removeObject(forKey: "appointment_endTime")
        userDefaults.removeObject(forKey: "appointment_notes")
        
        userDefaults.synchronize()
    }
    
}
