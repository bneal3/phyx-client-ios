//
//  MainViewController.swift
//  Phyx
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import PubNub
import SVProgressHUD
import RealmSwift
import Realm

class MainViewController: UINavigationController {
    
    var userToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializePubNub()
        initializeUserListener()
        initialize()
    }
    
    private func initialize() {

        let contactVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
        contactVC.title = "Chats"
        
        let contactNav = UINavigationController(rootViewController: contactVC)
        
    }
    
    func initializeUserListener() {
        let realm = try! Realm()
        let results = realm.objects(User.self)
        userToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                let channels = results.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                // TODO: Change how channels are updated
                let channels = results.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        userToken?.invalidate()
    }
}

extension MainViewController: PNObjectEventListener {
    
    // PubNub
    private func initializePubNub() {
        
        PNWrapper.shared().client.addListener(self)
        PNWrapper.shared().client.subscribeToChannels([UserData.shared().getId()], withPresence: false)
        
    }
    
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            // Message has been received on channel group stored in message.data.subscription.
        } else {
            // Message has been received on channel stored in message.data.channel.
        }
        
        // print("Received message: \(message.data.message) on channel \(message.data.channel) " +
            // "at \(message.data.timetoken)")
        if let data = message.data.message as? [String: Any] {
            if let name = data["name"] as? String {
                if name == "user" {
                    if let userData = data["data"] as? [String: Any] {
                        let user = User(userData: userData)
                        print(user)
                        RealmService.shared.createIfNotExists(user)
                    }
                }
            }
        }
    }
    
    // New presence event handling.
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.channel != event.data.subscription {
            // Presence event has been received on channel group stored in event.data.subscription.
        } else {
            // Presence event has been received on channel stored in event.data.channel.
        }
        
        if event.data.presenceEvent != "state-change" {
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        } else {
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) on \(event.data.channel) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    // Handle subscription status change.
    func client(_ client: PubNub, didReceive status: PNStatus) {
        if status.operation == .subscribeOperation {
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                    // Select last object from list of channels and send message to it.
                    let targetChannel = client.channels().last!
                    client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel,
                                   compressed: false, withCompletion: { (publishStatus) -> Void in
                        if !publishStatus.isError {
                            // Message successfully published to specified channel.
                        } else {
                            /**
                             Handle message publish error. Check 'category' property to find out
                             possible reason because of which request did fail.
                             Review 'errorData' property (which has PNErrorData data type) of status
                             object to get additional information about issue.
                             
                             Request can be resent using: publishStatus.retry()
                             */
                        }
                    })
                } else {
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            } else if status.category == .PNUnexpectedDisconnectCategory {
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            } else {
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
                if let errorStatus = status as? PNErrorStatus {
                    if errorStatus.category == .PNAccessDeniedCategory {
                        /**
                         This means that PAM does allow this client to subscribe to this channel and channel group
                         configuration. This is another explicit error.
                         */
                    } else {
                        /**
                         More errors can be directly specified by creating explicit cases for other error categories
                         of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                         `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                         or `PNNetworkIssuesCategory`
                         */
                    }
                }
            }
        }
    }
}
