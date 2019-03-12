//
//  RealmService.swift
//  stat
//
//  Created by Benjamin Neal on 1/30/18.
//  Copyright © 2018 Benjamin Neal. All rights reserved.
//

import Foundation
import RealmSwift

// Realm wrapper class
class RealmService {
    
    private init() {}
    static let shared = RealmService()
    
    // FUNCTION: Sets default Realm file for signed in user
    func setDefaultRealmForUser(id: String) {
        var config = Realm.Configuration.defaultConfiguration
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(id).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    // USAGE: Creates a new Realm object saved to memory
    func create<T: Object>(_ object: T) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    // USAGE: Creates a new Realm object is the object doesn't exist, otherwise updates the object
    func createIfNotExists<T: Object>(_ object: T) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch {
            post(error)
        }
    }
    
    // USAGE: Updates Realm object fields
    // TODO: Transfer Realm updating over to this function
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        let realm = try! Realm()
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    // USAGE: Deletes a Realm object
    func delete<T: Object>(_ object: T) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    func write(_ completion: @escaping() -> Void) {
        let realm = try! Realm()
        do {
            try realm.write {
                completion()
            }
        } catch {
            post(error)
        }
    }
    
    // USAGE: Used to delete all Realm objects on a user's phone
    func resetRealmInstallation() {
        var config = Realm.Configuration()
        var directory: URL?
        
        // FLOW: Sets default directory
        directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // FLOW: Checks if directory is valid
        if let directory = directory {
            var contents: [URL]?
            // FLOW: Gets all contents of directory
            do {
                contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            } catch {
                post(error)
            }
            
            // FLOW: Check if contents are valid
            if let contents = contents {
                // FLOW: Delete all paths with the realm extension
                for path in contents {
                    print(path)
                    let extensions = path.absoluteString.split(separator: ".")
                    if extensions.count > 1, extensions[1] == "realm" {
                        do {
                            try FileManager.default.removeItem(at: path)
                            print("File deleted")
                        } catch {
                            post(error)
                        }
                    }
                }
            }
        } else {
            print("Could not retrieve directory: Documents")
        }
    }
    
    // Realm Error Observers
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"),
                                               object: nil,
                                               queue: nil) { (notification) in
                                                completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
    }
    
}
