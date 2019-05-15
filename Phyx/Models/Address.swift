//
//  Address.swift
//  Phyx
//
//  Created by Benjamin Neal on 3/21/19.
//  Copyright © 2019 Phyx, Inc. All rights reserved.
//

import Foundation

class Address {
    var number: Int? = nil
    var street: String = ""
    var alt: String = ""
    var city: String = ""
    var state: String = ""
    var areaCode: Int? = nil
    
    var digits: String {
        if let number = number {
            return String(number)
        }
        return ""
    }
    
    var code: String {
        if let areaCode = areaCode {
            return String(areaCode)
        }
        return ""
    }
    
    convenience init(address: String) {
        self.init()
        
        var segments = address.split(separator: ",")
        var streetData = segments[0].split(separator: " ")
        if let number = Int(String(streetData[0])) {
            self.number = number
            for i in 1..<streetData.count {
                if i != 1 {
                    self.street += " "
                }
                self.street += String(streetData[i])
            }
        } else {
            for i in 0..<streetData.count {
                if i != 0 {
                    self.street += " "
                }
                self.street += String(streetData[i])
            }
        }
        
        if segments.count > 1 {
            self.city = String(segments[1])
        }
        
        if segments.count > 2 {
            var stateData = segments[2].split(separator: " ")
            self.state = String(stateData[0])
            if stateData.count > 1, let areaCode = Int(String(stateData[1])) {
                self.areaCode = areaCode
            }
        }
    }
    
}
