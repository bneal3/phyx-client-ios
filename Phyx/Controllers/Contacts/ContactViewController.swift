//
//  ContactViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SVProgressHUD
import Popover
import PubNub
import RealmSwift
import Realm

class ContactViewController: UIViewController {

    var btnMenu: UIBarButtonItem!
    var btnBack: UIBarButtonItem!
    
    var services = SERVICES
    var isAdditional = false
    
    var userToken: NotificationToken? = nil
    var contractorToken: NotificationToken? = nil
    var appointmentToken: NotificationToken? = nil
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
    
    var menuOptions = ["My Appointments", "Account", "Change Password", "Support"]
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var menuVisible = false
    
    var popover: Popover!
    var tutorial: Int = 0
    var tutorialTitles: [String] = [
        "Chats Screen",
        "New Conversation"
    ]
    var tutorialDescriptions: [String] = [
        "Your chats will appear here. Find new friends by going to your profile on the far right tab.",
        "Tap on the plus button to make a new chat. This is where you can add people in your address book as well as invite new friends."
    ]
    var tutorialDirections: [PopoverOption] = [
        .type(.down),
        .type(.down)
    ]
    var tutorialPositions: [CGPoint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        initializePubNub()
        initializeListeners()
        initialize()
//        if UserData.shared().isFirstTimeUsage(screen: "services") {
//            initiateTutorial()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.navigationController?.isNavigationBarHidden = true
        
        
    }

    private func initialize() {
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let navHeight: CGFloat = self.navigationController!.navigationBar.frame.height

        tableView.delegate = self
        tableView.dataSource = self
        
        let serviceXib = UINib(nibName: "CampCell", bundle: nil)
        tableView.register(serviceXib, forCellReuseIdentifier: CampCell.identifier)
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        let menuXib = UINib(nibName: "SettingCell", bundle: nil)
        menuTableView.register(menuXib, forCellReuseIdentifier: SettingCell.identifier)
        
        btnMenu = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.clickedMenu))
        
        btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: .plain, target: self, action: #selector(self.clickedBack))
        
        if !isAdditional {
            self.navigationItem.leftBarButtonItem = btnMenu
        } else {
            self.navigationItem.leftBarButtonItem = btnBack
        }
        
        tutorialPositions = [
            CGPoint(x: tableView.center.x, y: tableView.center.y - 100),
            CGPoint(x: self.view.frame.width - 32, y: barHeight + navHeight)
        ]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeDown)
        
        populateMenu()
        
        let locationManager = LocationManager.sharedInstance
        locationManager.showVerboseMessage = true
        locationManager.startUpdatingLocation()
    }
    
    deinit {
        userToken?.invalidate()
        contractorToken?.invalidate()
        appointmentToken?.invalidate()
    }
    
    @objc func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if let swipeGesture = sender as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if !menuVisible {
                    clickedMenu()
                }
            case UISwipeGestureRecognizer.Direction.left:
                if menuVisible {
                    clickedMenu()
                }
            default:
                break
            }
        }
    }
    
    func populateMenu() {
        userName.text = UserData.shared().getUserPersonalName()
        
        userAvatar.layer.masksToBounds = true
        userAvatar.layer.cornerRadius = userAvatar.frame.width / 2
        
        if let avatar = UserData.shared().getAvatar() {
            FSWrapper.wrapper.loadImage(url: URL(string: avatar)!, completion: { (image, error) in
                self.userAvatar.image = image
            })
        } else {
            userAvatar.image = UIImage(named: "AvatarPlaceholder")
        }
    }
    
    func initiateTutorial() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.showDescription()
        })
    }
    
    private func showDescription() {
        
        let width = self.view.frame.width - 100
        let aView = UIView(frame: CGRect(x: 0, y: 50, width: width, height: 220))
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: width, height: 30))
        titleLabel.font = UIFont.init(name: "Avenir Book", size: 19.0)
        titleLabel.textColor = UIColor.black
        titleLabel.text = tutorialTitles[tutorial]
        aView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 20, y: 50, width: self.view.frame.width - 140, height: 120))
        descriptionLabel.center.x = aView.center.x
        descriptionLabel.font = UIFont.init(name: "Avenir Book", size: 15.0)
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.text = tutorialDescriptions[tutorial]
        descriptionLabel.numberOfLines = 5
        aView.addSubview(descriptionLabel)
        
        let btnGot = UIButton(frame: CGRect(x: aView.frame.width / 2 - 45, y: 190, width: 90, height: 30))
        btnGot.titleLabel?.font = UIFont(name: "Avenir Book", size: 17.0)
        btnGot.setTitle("Got it", for: .normal)
        btnGot.setTitleColor(UIColor.init(red: 246.0/255, green: 104.0/255, blue: 95.0/255, alpha: 1.0), for: .normal)
        btnGot.addTarget(self, action: #selector(self.clickedGotIt), for: .touchUpInside)
        aView.addSubview(btnGot)
        
        var options = [
            .cornerRadius(6),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.init(red: 169.0/255, green: 169.0/255, blue: 169.0/255, alpha: 0.6)),
            .arrowSize(CGSize(width: 10, height: 8))
            ] as [PopoverOption]
        options.append(tutorialDirections[tutorial])
        popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(aView, point: tutorialPositions[tutorial])
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                popover.show(aView, point: tutorialPositions[tutorial])//CGPoint(x: 40, y: self.levelView.center.y + 120))
                break
            case 1334:
                popover.show(aView, point: tutorialPositions[tutorial])
                break
            default:
                popover.show(aView, point: tutorialPositions[tutorial])
                break
            }
            
        }
    }
    
    @objc func clickedGotIt() {
        popover.dismiss()
        if tutorial < tutorialTitles.count - 1 {
            tutorial += 1
            self.showDescription()
        } else {
            tutorial = 0
            UserData.shared().setFirstTimeUsage(screen: "chats")
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        tableView.contentInset = insets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
    }
    
    @objc func clickedMenu() {
        if !menuVisible {
            tableViewLeading.constant = menuView.frame.width
            tableViewTrailing.constant = -menuView.frame.width
            
            menuVisible = true
        } else {
            tableViewLeading.constant = 0
            tableViewTrailing.constant = 0
            
            menuVisible = false
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func clickedBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func logOutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            // FLOW: Send API request to logout
            ApiService.shared().logout(onSuccess: { (response) in }, onFailure: { (error) in })
            
            UserData.shared().logout()
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate!.window!.rootViewController?.dismiss(animated: false) {}
            appDelegate?.setLoginScreen()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ContactViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        tableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
}

extension ContactViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return services.count
        } else {
            return menuOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return tableView.frame.height / CGFloat(services.count)
        } else {
            return menuTableView.frame.height / CGFloat(menuOptions.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: CampCell.identifier, for: indexPath) as! CampCell
            
            cell.setCell(service: services[indexPath.row])
            
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
            
            cell.configureCell(text: menuOptions[indexPath.row], sw: false)
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if services.count == SERVICES.count {
                if indexPath.row != 2 {
                    let serviceVC = ServiceDetailsViewController()
                    serviceVC.details = services[indexPath.row]
                    self.navigationController?.pushViewController(serviceVC, animated: true)
                } else {
                    let serviceVC = ContactViewController(nibName: "ContactViewController", bundle: nil)
                    serviceVC.title = "Massages"
                    serviceVC.services = MASSAGES
                    serviceVC.isAdditional = true
                    self.navigationController?.pushViewController(serviceVC, animated: true)
                }
            } else {
                let serviceVC = ServiceDetailsViewController()
                serviceVC.details = services[indexPath.row]
                self.navigationController?.pushViewController(serviceVC, animated: true)
            }
        } else {
            
            if indexPath.row == 0 {
                let appointmentListVC = AppointmentListViewController()
                self.navigationController?.pushViewController(appointmentListVC, animated: true)
            }
//            else if indexPath.row == 1 {
//                // TODO: Open payment methods list
//            }
            else if indexPath.row == 1 {
                let editProfileVC = EditProfileViewController()
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            } else if indexPath.row == 2 {
                let changePasswordVC = ChangePasswordViewController()
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            } else if indexPath.row == 3 {
                let giveFeedbackVC = GiveFeedBackViewController()
                self.navigationController?.pushViewController(giveFeedbackVC, animated: true)
            }
            
        }
    }
    
    //func getPassedTime(date: Date) -> String {
    //
    //    let MIN: Double = 60 * 1000
    //    let HOUR: Double = MIN * 60
    //    let DAY: Double = HOUR * 24
    //    let WEEK: Double = DAY * 7
    //
    //    let dateFormatter = DateFormatter()
    //    dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
    //
    //    let dateInMillis = date.toMillis()
    //    let now = Date().toMillis()
    //    let timestamp = Double(now! - dateInMillis!)
    //
    //    let calendar = NSCalendar.current
    //
    //    var dateFormat = "h:mm a"
    //    var special = ""
    //    if timestamp > Double(1 * WEEK) {
    //        dateFormat = "MM/dd/yyyy"
    //    } else if timestamp > Double(1 * DAY) {
    //        dateFormat = "EEEE"
    //    } else if !calendar.isDateInToday(date) {
    //        special = "Yesterday"
    //    } else {
    //        if Int(timestamp / MIN) == 0 {
    //            special = "Just now"
    //        }
    //    }
    //
    //    if special == "" {
    //        dateFormatter.dateFormat = dateFormat
    //        return dateFormatter.string(from: date)
    //    } else {
    //        return special
    //    }
    //}
    
}

extension ContactViewController {
    
    func initializeListeners() {
        let realm = try! Realm()
        
        let users = realm.objects(User.self)
        userToken = users.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                let channels = users.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                let channels = users.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
        let contractors = realm.objects(Contractor.self)
        contractorToken = contractors.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                let channels = contractors.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                let channels = contractors.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
        
        let appointments = realm.objects(Appointment.self)
        appointmentToken = appointments.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                let channels = appointments.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                let channels = appointments.map{ $0.id }
                PNWrapper.shared().client.subscribeToChannels(Array(channels), withPresence: false)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
}

extension ContactViewController: PNObjectEventListener {
    
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
                        if user.id == UserData.shared().getId() {
                            UserData.shared().setUser(token: UserData.shared().getToken()!, user: user)
                        }
                        RealmService.shared.createIfNotExists(user)
                    }
                } else if name == "contractor" {
                    if let contractorData = data["data"] as? [String: Any] {
                        let contractor = Contractor(contractorData: contractorData)
                        print(contractor)
                        RealmService.shared.createIfNotExists(contractor)
                    }
                } else if name == "appointment" {
                    if let appointmentData = data["data"] as? [String: Any] {
                        let appointment = Appointment(appointmentData: appointmentData)
                        print(appointment)
                        RealmService.shared.createIfNotExists(appointment)
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
                    if let targetChannel = client.channels().last {
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
                    }
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

