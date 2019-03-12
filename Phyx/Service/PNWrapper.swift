//
//  PNWrapper.swift
//  Camp
//
//  Created by Benjamin Neal on 2/27/19.
//  Copyright © 2019 sonnaris. All rights reserved.
//

import Foundation
import PubNub

// PubNub wrapper
class PNWrapper {
    
    private static var sharedPNWrapper: PNWrapper = {
        let instance = PNWrapper()
        let configuration = PNConfiguration(publishKey: PN_PUBLISH_KEY, subscribeKey: PN_SUBSCRIBER_KEY)
        instance.client = PubNub.clientWithConfiguration(configuration)
        return instance
    }()
    
    class func shared() -> PNWrapper {
        return sharedPNWrapper
    }
    
    var client: PubNub!
    
    func getUsersPresent(name: String, onCompletion completion: @escaping(_ result: NSNumber?) -> Void) {
        client.hereNowForChannel(name) { (result, error) in
            if let result = result {
                completion(result.data.occupancy)
            } else {
                completion(nil)
            }
        }
    }
}
