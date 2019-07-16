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
        "description": "Chiropractic is a form of alternative medicine mostly concerned with the diagnosis and treatment of mechanical disorders of the musculoskeletal system including the spine.",
        "price": 14900
    ],
    [
        "serviceId": 1,
        "name": "Reiki",
        "image": "logo",
        "description": "Reiki is a form of alternative medicine called energy healing. Reiki practitioners use a technique called palm healing or hands-on healing through which a \"universal energy\" is said to be transferred through the palms of the practitioner to the patient in order to encourage emotional or physical healing.",
        "price": 16900
    ],
    [
        "serviceId": -1,
        "name": "Massage",
        "image": "logo",
        "description": "",
        "price": -1
    ],
    [
        "serviceId": 8,
        "name": "Acupuncture",
        "image": "logo",
        "description": "Acupuncture is a complementary medical practice that entails stimulating certain points on the body, most often with a needle penetrating the skin, to alleviate pain or to help treat various health conditions.",
        "price": 14900
    ],
    [
        "serviceId": 9,
        "name": "Physical Therapy",
        "image": "logo",
        "description": "Physical therapy is one of the allied health professions that, by using mechanical force and movements, manual therapy, exercise therapy, and electrotherapy, remediates impairments and promotes mobility and function.",
        "price": 14900
    ]
]

var MASSAGES: [[String: Any]] = [
    [
        "serviceId": 2,
        "name": "Swedish",
        "image": "logo",
        "description": "Swedish massage is a gentle type of full-body massage that’s ideal for people who are either new to massage, have a lot of tension or are sensitive to touch.",
        "price": 8900
    ],
    [
        "serviceId": 3,
        "name": "Deep Tissue",
        "image": "logo",
        "description": "Deep tissue massage uses more pressure than a Swedish massage. It’s a good option if you have chronic muscle problems, such as soreness, injury, or imbalance. It can help relieve tight muscles, chronic muscle pain, and anxiety.",
        "price": 8900
    ],
    [
        "serviceId": 4,
        "name": "Sports",
        "image": "logo",
        "description": "Sports massage is a good option if you have a repetitive use injury to a muscle, such as what you may get from playing a sport. It’s also a good option if you’re prone to injuries because it can be used to help prevent sports injuries. You may also use sports massage to increase flexibility and performance.",
        "price": 8900
    ],
    [
        "serviceId": 5,
        "name": "Pregnancy",
        "image": "logo",
        "description": "Prenatal massage can be a safe way for women to get a massage during pregnancy. It can help reduce pregnancy body aches, reduce stress, and ease muscle tension. You can get a massage at any time during your pregnancy.",
        "price": 8900
    ],
    [
        "serviceId": 6,
        "name": "Reflexology",
        "image": "logo",
        "description": "Reflexology is best for people who are looking to relax or restore their natural energy levels. Reflexology uses gentle to firm pressure on different pressure points of the feet, hands, and ears. You can wear loose, comfortable clothing that allows access to your legs.",
        "price": 8900
    ],
    [
        "serviceId": 7,
        "name": "Couples",
        "image": "",
        "description": "A couple’s massage is a massage that you do with your partner, friend, or family member in the same room.",
        "price": 8900
    ]
]

var MASSAGE_EXTENSIONS = [
    8900,
    9900,
    13900,
    16900
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
