//
//  PushNotifications.swift
//  Phyx
//
//  Created by Benjamin Neal on 1/14/19.
//  Copyright © 2019 sonnaris. All rights reserved.
//

import Foundation
import OneSignal

// OneSignal Wrapper
class PushNotifications {
    
    private init() {}
    static let shared = PushNotifications()
    
    func sendPushNotification(membersToPush: [String], message: String, title: String?) {
        
        OneSignal.postNotification(["headings": ["en": UserData.shared().getUserPersonalName()], "subtitle": ["en": title ?? ""], "contents": ["en": message], "ios_badgeType": "Increase", "ios_badgeCount" : "1", "include_player_ids" : membersToPush, "mutable_content": true])
        
    }
    
}



