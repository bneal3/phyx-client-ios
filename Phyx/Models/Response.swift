//
//  Response.swift
//  Camp
//
//  Created by Benjamin Neal on 12/30/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import Foundation

// API Response Model
class Response {
    
    var _status: Int = -1
    var _message: String = ""
    var _object: [String: Any] = [:]
    var _headers: [AnyHashable: Any] = [:]
    
    var status: Int {
        return _status
    }
    
    var message: String {
        return _message
    }
    
    var object: [String: Any] {
        return _object
    }
    
    var headers: [AnyHashable: Any] {
        return _headers
    }
    
    convenience init(responseData: [String: Any]){
        self.init()
        
        if let status = responseData[CODE] as? Int {
            self._status = status
        }
        
        if let message = responseData[MESSAGE] as? String {
            self._message = message
        }
        
        if let object = responseData[RESPONSE] as? [String: Any] {
            self._object = object
        }
        
        if let headers = responseData[HEADERS] as? [AnyHashable: Any] {
            self._headers = headers
        }
        
    }
}
