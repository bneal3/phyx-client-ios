//
//  Service.swift
//  Phyx
//
//  Created by Benjamin Neal on 3/12/19.
//  Copyright © 2019 Phyx, Inc. All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

class Service {
    
    var name: String = ""
    var photo: String = ""
    var description: String = ""
    
    convenience init(serviceData: [String: Any]){
        self.init()
        
        if let name = serviceData["name"] as? String {
            self.name = name
        }
        
        if let photo = serviceData["photo"] as? String {
            self.photo = photo
        }
        
        if let description = serviceData["description"] as? String {
            self.description = description
        }
        
    }
    
}
