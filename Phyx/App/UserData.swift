//
//  UserData.swift
//  Camp
//
//  Created by sonnaris on 8/22/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import OneSignal
import RealmSwift

class UserData {
    
    private static var sharedData: UserData = {
        let data = UserData()
        return data
    }()

    class func shared() -> UserData {
        return sharedData
    }
    
    // Set
    public func setUser(token: String, user: User) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "user_login")
        
        userDefaults.set(user.id, forKey: "user_id")
        userDefaults.set(token, forKey: "user_token")
        
        userDefaults.set(user.phone, forKey: "user_phone")
        
        userDefaults.set(user.birthday, forKey: "user_birthday")
        userDefaults.set(user.name, forKey: "user_name")
        
        if let avatar = user.avatar {
            userDefaults.set(avatar, forKey: "user_avatar")
        }
        
        userDefaults.synchronize()
    }
    
    public func setTutorial() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "user_first_time_leaderboards")
        userDefaults.set(true, forKey: "user_first_time_chats")
        userDefaults.set(true, forKey: "user_first_time_profile")
        
        userDefaults.synchronize()
    }
    
    public func setPhone(phone: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(phone, forKey: "user_phone")
        userDefaults.synchronize()
    }
    
    public func setPassword(password: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(password, forKey: "user_password")
        userDefaults.synchronize()
    }
    
    public func setBirthday(birthday: Int64) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(birthday, forKey: "user_birthday")
        userDefaults.synchronize()
    }
    
    public func setName(name: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(name, forKey: "user_name")
        userDefaults.synchronize()
    }
    
    public func setAvatar(avatar: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(avatar, forKey: "user_avatar")
        userDefaults.synchronize()
    }
    
    
    // Get
    public func getUser() -> User {
        var userData: [String: Any] = [:]
        
        let userDefaults = UserDefaults.standard
        let id = userDefaults.object(forKey: "user_id")
        userData["_id"] = id
        
        var identifiers: [[String: Any]] = []
        let phone = userDefaults.object(forKey: "user_phone")
        identifiers.append(["method": "phone", "value": phone])
        userData["identifiers"] = identifiers
        
        let birthday = userDefaults.object(forKey: "user_birthday") as! Int64
        userData["birthday"] = birthday
        
        var name = ""
        if let _name = userDefaults.object(forKey: "user_name") as? String {
            name = _name
        }
        userData["name"] = name
        var avatar = ""
        if let _avatar = userDefaults.object(forKey: "user_avatar") as? String {
            avatar = _avatar
        }
        userData["avatar"] = avatar
        
        let user = User(userData: userData)
        return user
    }
    
    public func getId() -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "user_id") as! String
    }
    
    public func isLogged() -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: "user_login")
    }
    
    public func getToken() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "user_token") as? String
    }
    
    public func getPhone() -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "user_phone") as! String
    }
    
    public func getUserPassword() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "user_password") as? String
    }
    
    public func getUserBirthday() -> Int64 {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "user_birthday") as! Int64
    }
    
    public func getUserPersonalName() -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "user_name") as! String
    }
    
    public func getAvatar() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "user_avatar") as? String
    }
    
    // First time usage
    public func setFirstTimeUsage(screen: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "user_first_time_\(screen)")
        userDefaults.synchronize()
    }
    
    public func isFirstTimeUsage(screen: String) -> Bool {
        let userDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: "user_first_time_\(screen)")
    }
    
    // Logout
    public func logout() {

        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "user_id")
        userDefaults.removeObject(forKey: "user_login")
        userDefaults.removeObject(forKey: "user_token")
        
        userDefaults.removeObject(forKey: "user_phone")
        
        userDefaults.removeObject(forKey: "user_password")
        userDefaults.removeObject(forKey: "user_birthday")
        
        userDefaults.removeObject(forKey: "user_name")
        userDefaults.removeObject(forKey: "user_avatar")
        
        userDefaults.removeObject(forKey: "user_first_time_leaderboards")
        userDefaults.removeObject(forKey: "user_first_time_chats")
        userDefaults.removeObject(forKey: "user_first_time_profile")
        
        userDefaults.synchronize()
    }
    
    func getPlayerId() -> String? {

        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()

        if let userId = status.subscriptionStatus.userId {
            return userId
        }
        return nil
    }
}
