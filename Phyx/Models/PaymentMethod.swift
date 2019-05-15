//
//  PaymentMethod.swift
//  Phyx
//
//  Created by Benjamin Neal on 3/21/19.
//  Copyright © 2019 Phyx, Inc. All rights reserved.
//

import Foundation
import RealmSwift

enum PAYMENT_METHODS: Int {
    case Card = 0
    case ApplePay
}

// Local Payment Method Model
@objcMembers class PaymentMethod: Object {
    
    dynamic var name: String = ""
    dynamic var card: Int64 = -1
    dynamic var nonce: String = ""
    dynamic var month: Int = 0
    dynamic var year: Int = 0
    dynamic var billing: String = ""

    var address: Address {
        get {
            return Address(address: billing)
        }
    }
    
    convenience init(paymentData: [String: Any]){
        self.init()
        
        if let name = paymentData["name"] as? String {
            self.name = name
        }
        
        if let card = paymentData["card"] as? Int64 {
            self.card = card
        }
        
        if let nonce = paymentData["nonce"] as? String {
            self.nonce = nonce
        }
        
        if let month = paymentData["month"] as? Int {
            self.month = month
        }
        
        if let year = paymentData["year"] as? Int {
            self.year = year
        }
        
        if let billing = paymentData["billing"] as? String {
            self.billing = billing
        }
        
    }
    
    override static func primaryKey() -> String? {
        return "card"
    }
    
}

