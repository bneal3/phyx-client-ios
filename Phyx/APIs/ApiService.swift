//
//  ApiService.swift
//  Phyx
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
    
    // Contractors
    
    func getContractors(path: String, onSuccess success: @escaping(_ result: [Contractor]) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.get
        request.path = "/contractors?" + path
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            if let json = response.object["contractors"] as? [[String: Any]] {
                
                var contractors = [Contractor]()
                for contractorData in json {
                    let contractor = Contractor(contractorData: contractorData)
                    contractors.append(contractor)
                }
                
                success(contractors)
                
            } else {
                
                failure(response)
                
            }
            
        }, onError: failure)
        
    }
    
    func getContractor(id: String, onSuccess success: @escaping(_ result: Contractor) -> Void, onFailure failure: @escaping(_ result: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.get
        request.path = "/contractors/id/" + id
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            if response.object.count > 0 {
                
                let contractor = Contractor(contractorData: response.object)
                
                RealmService.shared.createIfNotExists(contractor)
                
                success(contractor)
                
            } else {
                
                failure(response)
                
            }
            
        }, onError: failure)
        
    }
    
    // Profile
    
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
    
    // Appointments
    
    func postAppointment(service: Int, meetingTime: Int64, location: String, length: Int?, notes: String, amount: Int, chargeId: String, onSuccess success: @escaping(_ result: Appointment) -> Void, onFailure failure: @escaping(_ error: Any) -> Void) {
        
        var parameters = [
            "service": service,
            "meetingTime": meetingTime,
            "location": location,
            "notes": notes,
            "amount": amount,
            "chargeId": chargeId
        ] as [String : Any]
        
        if let length = length {
            parameters["length"] = length
        }
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/appointments"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            let appointment = Appointment(appointmentData: response.object)
            
            RealmService.shared.createIfNotExists(appointment)
            PNWrapper.shared().client.subscribeToChannels([appointment.id], withPresence: false)
            
            success(appointment)
            
        }, onError: failure)
        
    }
    
    func getAppointment(id: String, onSuccess success: @escaping(_ result: Appointment) -> Void, onFailure failure: @escaping(_ error: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.get
        request.path = "/appointments/id/" + id
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            let appointment = Appointment(appointmentData: response.object)
            
            RealmService.shared.createIfNotExists(appointment)
            PNWrapper.shared().client.subscribeToChannels([appointment.id], withPresence: false)
            
            success(appointment)
            
        }, onError: failure)
        
    }
    
    func getAppointments(onSuccess success: @escaping(_ result: [Appointment]) -> Void, onFailure failure: @escaping(_ error: Any) -> Void) {
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.get
        request.path = "/appointments/client"
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            if let json = response.object["appointments"] as? [[String: Any]] {
                
                var appointments = [Appointment]()
                for appointmentData in json {
                    let appointment = Appointment(appointmentData: appointmentData)
                    
                    RealmService.shared.createIfNotExists(appointment)
                    PNWrapper.shared().client.subscribeToChannels([appointment.id], withPresence: false)
                    
                    appointments.append(appointment)
                }
                
                success(appointments)
                
            } else {
                
                failure(response)
                
            }
            
        }, onError: failure)
        
    }
    
    func patchAppointment(id: String, service: Int, meetingTime: Int64, status: Int, location: String, length: Int?, notes: String, rating: Int?, onSuccess success: @escaping(_ result: Appointment) -> Void, onFailure failure: @escaping(_ error: Any) -> Void) {
        
        var parameters = [
            "service": service,
            "meetingTime": meetingTime,
            "status": status,
            "location": location,
            "notes": notes,
            "rating": rating
        ] as [String : Any]
        
        if let length = length {
            parameters["length"] = length
        }
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.patch
        request.path = "/appointments/id/" + id + "/client"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            let appointment = Appointment(appointmentData: response.object)
            
            RealmService.shared.createIfNotExists(appointment)
            PNWrapper.shared().client.subscribeToChannels([appointment.id], withPresence: false)
            
            success(appointment)
            
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
    
    // Payments
    
//    func createKey(apiVersion: String, onSuccess success: @escaping (_ result: Response) -> Void, onFailure failure: @escaping (_ error: Any) -> Void) {
//        
//        var request: HTTPRequest = HTTPRequest()
//        request.method = HTTPMethod.post
//        request.path = "/payments/key?api_version=" + apiVersion
//        
//        REQWrapper.shared.send(request: request, onSuccess: { response in
//            success(response)
//            
//        }, onError: failure)
//        
//    }
    
    func charge(token: String, amount: Int, category: String, meetingTime: Int64, appointmentId: String?,  onSuccess success: @escaping (_ result: Response) -> Void, onFailure failure: @escaping (_ error: Any) -> Void) {
        
        let parameters = [
            "token": token,
            "amount": amount,
            "category": category,
            "meetingTime": meetingTime,
            "appointmentId": appointmentId
        ] as [String : Any]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/payments/appointment"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            success(response)
            
        }, onError: failure)
        
    }
    
    func tip(token: String, amount: Int, meetingTime: Int64, appointmentId: String, onSuccess success: @escaping (_ result: Response) -> Void, onFailure failure: @escaping (_ error: Any) -> Void) {
        
        let parameters = [
            "token": token,
            "amount": amount,
            "meetingTime": meetingTime,
            "appointmentId": appointmentId
        ] as [String : Any]
        
        var request: HTTPRequest = HTTPRequest()
        request.method = HTTPMethod.post
        request.path = "/payments/tip"
        request.parameters = parameters
        
        REQWrapper.shared.send(request: request, onSuccess: { response in
            
            success(response)
            
        }, onError: failure)
        
    }
    
    
    class func shared() -> ApiService {
        return sharedApiService
    }
    
}
