//
//  Contractor.swift
//  Phyx
//
//  Created by Benjamin Neal on 3/21/19.
//  Copyright © 2019 Phyx, Inc. All rights reserved.
//

import Foundation
import RealmSwift

// API Contractor Model
@objcMembers class Contractor: Object {
    
    dynamic var id: String = ""
    dynamic var phone: String = ""
    dynamic var paymentId: String? = nil
    dynamic var first: String = ""
    dynamic var last: String = ""
    dynamic var address: String = ""
    dynamic var birthday: Int64 = 0
    
    dynamic var bio: String = ""
    dynamic var avatar: String? = nil
    dynamic var video: String? = nil
    var services: List<Int> = List<Int>()
    var rating: Float? = nil
    
    dynamic var submitted: Bool = false
    dynamic var approved: Bool = false
    
    convenience init(contractorData: [String: Any]){
        self.init()
        
        if let id = contractorData["_id"] as? String {
            self.id = id
        }
        
        if let identifiers = contractorData["identifiers"] as? [[String: Any]] {
            for identifier in identifiers {
                if let method = identifier["method"] as? String, let value = identifier["value"] as? String {
                    if method == "phone" {
                        self.phone = value
                    } else if method == "paymentId" {
                        self.paymentId = value
                    }
                }
            }
        }
        
        if let nameData = contractorData["name"] as? [String: Any] {
            if let first = nameData["first"] as? String {
                self.first = first
            }
            
            if let last = nameData["last"] as? String {
                self.last = last
            }
        }
        
        if let address = contractorData["address"] as? String {
            self.address = address
        }
        
        if let birthday = contractorData["birthday"] as? Int64 {
            self.birthday = birthday
        }
        
        if let bio = contractorData["bio"] as? String {
            self.bio = bio
        }
        
        if let avi = contractorData["avatar"] as? String, avi != "" {
            self.avatar = avi
        }
        
        if let vid = contractorData["video"] as? String, vid != "" {
            self.video = vid
        }
        
        if let services = contractorData["services"] as? [Int] {
            self.services.append(objectsIn: services)
        }
        
        if let rating = contractorData["rating"] as? Float, rating > 0 {
            self.rating = rating
        }
        
        if let verificationData = contractorData["verification"] as? [String: Any] {
            if let submitted = verificationData["submitted"] as? Bool {
                self.submitted = submitted
            }
            if let approved = verificationData["approved"] as? Bool {
                self.approved = approved
            }
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
