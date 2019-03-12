//
//  ApiService.swift
//  Camp
//
//  Created by sonnaris on 8/22/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Realm
import RealmSwift

class ApiService {
    
    private static var sharedApiService: ApiService = {
        let apiService = ApiService()
        return apiService
    }()
    
    /*
     **  User registration/login and forgot password apis
     */
    
    func completeLogin(response: Response, password: String, onSuccess success: @escaping(_ result: User) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        guard response.status == 200 else {
            failure(response)
            return
        }
        
        var auth = "x-auth"
        if _env == Environment.production {
            auth = "X-Auth"
        }
        guard let token = response.headers[auth] as? String else {
            failure(response)
            return
        }
        
        let user = User(userData: response.object)
        UserData.shared().setUser(token: token, user: user)
        UserData.shared().setPassword(password: password)
        
        RealmService.shared.setDefaultRealmForUser(id: user.id)
        
        success(user)
    }
    
    func loginUser(identifier: String, password: String, onSuccess success: @escaping(_ result: User) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        let parameters : Parameters = [
            "username": identifier,
            "password": password
        ]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/users/login"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            self.completeLogin(response: response, password: password, onSuccess: success, onFailure: failure)
            
        }, onError: failure)
    }
    
    func registerUser(phone: String, name: String, password: String, birth: Int64, onSuccess success: @escaping(_ result: User) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        let parameters : Parameters = [
            "identifiers": [
                [
                    "method": "phone",
                    "value": phone
                ]
            ],
            "name": name,
            "password": password,
            "birthday": birth
        ]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/users"
        request.parameters = parameters
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            UserData.shared().setTutorial()
            self.completeLogin(response: response, password: password, onSuccess: success, onFailure: failure)
            
        }, onError: failure)
    }
    
    func sendCode(phone: String, onSuccess success: @escaping(_ result: Response) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        let parameters : Parameters = [
            "phone": phone
        ]

        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/users/verify/phone/send"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            success(response)

        }, onError: failure)
    }
    
    func verifyCode(code: String, phone: String, lock: Bool?, onSuccess success: @escaping(_ result: Response) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        let parameters: Parameters = [
            "code": code,
            "phone": phone,
            "lock": lock
        ]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/users/verify/phone/receive"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            success(response)
            
        }, onError: failure)
        
    }
    
    func getUsers(path: String, onSuccess success: @escaping(_ result: [User]) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.get
        request.path = "/users?" + path
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            if let json = response.object["users"] as? [[String: Any]] {
                
                var users = [User]()
                for userData in json {
                    let user = User(userData: userData)
                    users.append(user)
                }
                
                success(users)
                
            } else {
                
                failure(response)
                
            }
            
        }, onError: failure)
        
    }
    
    func getUser(id: String, onSuccess success: @escaping(_ result: User) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.get
        request.path = "/users/id/" + id
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            if response.object.count > 0 {
                
                let user = User(userData: response.object)
                success(user)
                
            } else {
                
                failure(response)
                
            }
            
        }, onError: failure)
        
    }
    
    func searchForUsers(term: String, onSuccess success: @escaping(_ result: [User]) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.get
        request.path = "/users/search?method=phone&term=" + term
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            if let json = response.object["users"] as? [[String: Any]] {
                
                var users = [User]()
                for userData in json {
                    let user = User(userData: userData)
                    users.append(user)
                }
                
                success(users)
                
            } else {
                
                failure(response)
                
            }
            
        }, onError: failure)
        
    }
    
    func changePassword(oldPassword: String, newPassword: String, onSuccess success: @escaping(_ result: Response) -> Void, onFailure failure: @escaping(_ error: Any) -> Void) {
        
        let parameters = [
            "old": oldPassword,
            "new": newPassword
        ]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.patch
        request.path = "/users/me/password"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            success(response)
            
        }, onError: failure)
        
    }
    
    func forgotPassword(newPassword: String, lock: String, onSuccess success: @escaping(_ result: User) -> Void, onFailure failure: @escaping(_ error: Any) -> Void) {
        
        let parameters = [
            "password": newPassword
        ]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.delete
        request.path = "/users/lock"
        request.parameters = parameters
        request.headers = ["x-lock": lock]
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            let user = User(userData: response.object)
            success(user)
            
        }, onError: failure)
        
    }
    
    func updateProfile(phone: String, name: String, avatar: String, onSuccess success: @escaping(_ result: User) -> Void, onFailure failure: @escaping(_ error: Any) -> Void) {
        
        let parameters = [
            "phone": phone,
            "name": name,
            "avatar": avatar
        ]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.patch
        request.path = "/users/me/profile"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            // FLOW: Update UserDefaults
            if response.object.count > 0 {
                
                let user = User(userData: response.object)
                UserData.shared().setUser(token: UserData.shared().getToken()!, user: user)
                success(user)
                
            } else {
                
                failure(response)
                
            }
            
        }, onError: failure)
        
    }
    
    // Settings
    
    func sendFeedback(subject: String, feedback: String, onSuccess success: @escaping (_ result: Response) -> Void, onFailure failure: @escaping (_ error: Any) -> Void) {

        let parameters = [
            "subject": subject,
            "body": feedback
        ]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/users/feedback"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            success(response)
            
        }, onError: failure)

    }
    
    func logout(onSuccess success: @escaping (_ result: Response) -> Void, onFailure failure: @escaping (_ error: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.delete
        request.path = "/users/me/token"
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
    
            success(response)
            
        }, onError: failure)
        
    }
    
    /* Users api end */
    
    
    class func shared() -> ApiService {
        return sharedApiService
    }
    
}
