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

var SERVICES: [[String: Any]] = [
    [
        "serviceId": 0,
        "name": "Chiropractic",
        "image": "logo",
        "description": "Chiropractic Services"
    ],
    [
        "serviceId": 1,
        "name": "Reiki",
        "image": "logo",
        "description": ""
    ],
    [
        "name": "Massage",
        "image": "logo",
        "description": ""
    ],
    [
        "serviceId": 8,
        "name": "Acupuncture",
        "image": "logo",
        "description": ""
    ],
    [
        "serviceId": 9,
        "name": "Physical Therapy",
        "image": "logo",
        "description": ""
    ]
]

var MASSAGES: [[String: Any]] = [
    [
        "serviceId": 2,
        "name": "Swedish",
        "image": "logo",
        "description": "Swedish Massage"
    ],
    [
        "serviceId": 3,
        "name": "Deep Tissue",
        "image": "logo",
        "description": "Deep Tissue Massage"
    ],
    [
        "serviceId": 4,
        "name": "Sports",
        "image": "logo",
        "description": "Sports Massage"
    ],
    [
        "serviceId": 5,
        "name": "Pregnancy",
        "image": "logo",
        "description": "Pregnancy Massage"
    ],
    [
        "serviceId": 6,
        "name": "Reflexology",
        "image": "logo",
        "description": "Reflexology Massage"
    ],
    [
        "serviceId": 7,
        "name": "Couples",
        "image": "",
        "description": "Couples Massage"
    ]
]

var PRICES = [
    149,
    169,
    89,
    89,
    89,
    89,
    89,
    89,
    89,
    149
]

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
