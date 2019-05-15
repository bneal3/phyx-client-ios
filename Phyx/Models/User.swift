//
//  User.swift
//  Phyx
//
//  Created by sonnaris on 9/3/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import Foundation
import RealmSwift

// API User Model
@objcMembers class User: Object {
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var phone: String = ""
    dynamic var birthday: Int64 = 0
    dynamic var avatar: String? = nil
    
    dynamic var rating: Float? = nil
    
    var isSelected = false
    
    
    convenience init(userData: [String: Any]){
        self.init()
        
        if let id = userData["_id"] as? String {
            self.id = id
        }
        
        if let name = userData["name"] as? String {
            self.name = name
        }
        
        if let identifiers = userData["identifiers"] as? [[String: Any]] {
            for identifier in identifiers {
                if let method = identifier["method"] as? String, let value = identifier["value"] as? String {
                    if method == "phone" {
                        self.phone = value
                    }
                }
            }
        }
        
        if let birthday = userData["birthday"] as? Int64 {
            self.birthday = birthday
        }
        
        if let avi = userData["avatar"] as? String, avi != "" {
            self.avatar = avi
        }
        
        if let rating = userData["rating"] as? Float, rating > 0 {
            self.rating = rating
        }

    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["isSelected"]
    }
}
