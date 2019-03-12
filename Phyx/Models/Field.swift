//
//  Field.swift
//  Camp
//
//  Created by Benjamin Neal on 1/29/19.
//  Copyright © 2019 sonnaris. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Field: Object {
    
    dynamic var key: String = ""
    dynamic var value: String = ""
    
    convenience init(key: String, value: String){
        self.init()
        
        self.key = key
        self.value = value
    }
    
    static func get(module: List<Field>, item: String) -> String? {
        let result = module.first { (field) -> Bool in
            return field.key == item
        }
        if let result = result {
            return result.value
        }
        return nil
    }
    
    static func set(module: List<Field>, item: String, value: String) {
        if let field = module.first(where: { $0.key == item }) {
            field.value = value
        } else {
            let field = Field(key: item, value: value)
            module.append(field)
        }
    }
    
    
//    func convert() -> [String: Any] {
//        let dictionary: [String: Any] = [
//            "key": key,
//            "value": value
//        ]
//        
//        return dictionary
//    }
}
