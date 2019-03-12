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

    var btnMenu : UIBarButtonItem!
    
    var serviceNames = ["Chiropractor", "Massage", "Physical Therapy", "Acupuncture"]
    var services = [Service]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
    
    var menuOptions = ["Appointment History", "Payment History", "Account", "Support"]
    
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
        
        self.navigationItem.leftBarButtonItem = btnMenu
        
        tutorialPositions = [
            CGPoint(x: tableView.center.x, y: tableView.center.y - 100),
            CGPoint(x: self.view.frame.width - 32, y: barHeight + navHeight)
        ]
        
        populateServices()
        populateMenu()
    }
    
    func populateServices() {
        for name in serviceNames {
            let service = Service(serviceData: ["name": name, "photo": "phyx-logo", "description": ""])
            services.append(service)
        }
        tableView.reloadData()
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
            
        } else {
            
        }
    }
    
    func getPassedTime(date: Date) -> String {
        
        let MIN: Double = 60 * 1000
        let HOUR: Double = MIN * 60
        let DAY: Double = HOUR * 24
        let WEEK: Double = DAY * 7
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.abbreviation()!)
        
        let dateInMillis = date.toMillis()
        let now = Date().toMillis()
        let timestamp = Double(now! - dateInMillis!)
        
        let calendar = NSCalendar.current
        
        var dateFormat = "h:mm a"
        var special = ""
        if timestamp > Double(1 * WEEK) {
            dateFormat = "MM/dd/yyyy"
        } else if timestamp > Double(1 * DAY) {
            dateFormat = "EEEE"
        } else if !calendar.isDateInToday(date) {
            special = "Yesterday"
        } else {
            if Int(timestamp / MIN) == 0 {
                special = "Just now"
            }
        }
        
        if special == "" {
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: date)
        } else {
            return special
        }
    }
}
