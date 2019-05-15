//
//  ProfileViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import Popover
import SwiftyAvatar
import SVProgressHUD

class ProfileViewController: UIViewController {

    var btnSetting: UIBarButtonItem!
    
    var btnSearch : UIBarButtonItem!
    var searchTextField: UITextField!
    var isSearching: Bool = false
    var btnClose : UIBarButtonItem!
    
    let btnChat: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .camp
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named: "Chat"), for: .normal)
        return button
    }()
    
    let btnBlock: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .camp
        button.layer.cornerRadius = 5
        button.setImage(UIImage(named: "icons8-no-chat-filled"), for: .normal)
        return button
    }()
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var coinView: UIView!
    @IBOutlet weak var statisticsView: UIView!
    
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var userNameView: UILabel!
    @IBOutlet weak var avatarView: SwiftyAvatar!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var scoreView: UILabel!
    @IBOutlet weak var levelNumberView: UILabel!
    @IBOutlet weak var coinNumberLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var coinNumberView: UIView!
    @IBOutlet weak var messageReceivedView: UIView!
    @IBOutlet weak var messageSentView: UIView!
    @IBOutlet weak var responseTimeView: UIView!
    
    @IBOutlet weak var messageReceivedLabel: UILabel!
    @IBOutlet weak var messageSentLabel: UILabel!
    @IBOutlet weak var responseTimeLabel: UILabel!
    
    var titleView: UILabel!
    var tableView: UITableView!
    
    var user: User!
    var users: [User] = []
    
    var popover: Popover!
    var tutorial: Int = 0
    var tutorialTitles: [String] = [
        "Status Tab",
        "HOT Balance",
        "Overall Statistics",
        "Find Users"
    ]
    var tutorialDescriptions: [String] = [
        "You can see your current score, experience points and level here. Gain experience by messaging up to level up and increase your place on the leaderboards!",
        "You can see your HOT balance here. Earn HOTs by first downloading the supplementary Camp Wallet app and then inviting your friends and leveling up.",
        "These are your overall messaging statistics. They give you a better idea on how you message.",
        "Tap the search button to see other people's profiles and chat with them."
    ]
    var tutorialDirections: [PopoverOption] = [
        .type(.down),
        .type(.down),
        .type(.up),
        .type(.down)
    ]
    var tutorialPositions: [CGPoint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        initialize()
        if UserData.shared().isFirstTimeUsage(screen: "profile") {
            initiateTutorial()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.navigationController?.isNavigationBarHidden = true
        
        if user == nil {
            user = UserData.shared().getUser()
        }
        updateUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        user = nil
    }
    
    private func initialize() {
        
        self.profileView.layer.cornerRadius = 3
        self.levelView.layer.cornerRadius = 3
        self.coinView.layer.cornerRadius = 3
        self.statisticsView.layer.cornerRadius = 3
        
        let path = UIBezierPath(rect: self.profileView.bounds)
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = 2
        border.fillColor = UIColor.clear.cgColor
        self.profileView.layer.addSublayer(border)
        self.levelView.layer.addSublayer(border)
        self.coinView.layer.addSublayer(border)
        self.statisticsView.layer.addSublayer(border)
        
        let coinsTap = UITapGestureRecognizer(target: self, action: #selector(self.clickedCoins))
        coinNumberView.addGestureRecognizer(coinsTap)
        
        let messageReceivedTap = UITapGestureRecognizer(target: self, action: #selector(self.clickedMessageReceived))
        messageReceivedView.addGestureRecognizer(messageReceivedTap)
        
        let messageSentTap = UITapGestureRecognizer(target: self, action: #selector(self.clickedMessageSent))
        messageSentView.addGestureRecognizer(messageSentTap)
        
        let responseTimeTap = UITapGestureRecognizer(target: self, action: #selector(self.clickedResponseTime))
        responseTimeView.addGestureRecognizer(responseTimeTap)
        
        titleView = UILabel(frame: CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 21.0))
        titleView.text = "Profile"
        titleView.font = UIFont(name: "Avenir Book", size: 18.0)
        titleView.textColor = UIColor.black
        titleView.textAlignment = .center
        
        self.navigationItem.titleView = titleView
        
        // Search
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let navHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        let tabBarHeight: CGFloat = (tabBarController?.tabBar.frame.height)!

        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - (barHeight + tabBarHeight)))
        self.view.addSubview(tableView)
        self.view.bringSubviewToFront(tableView)
        tableView.anchor(top: self.view.safeTopAnchor(), left: self.view.safeLeftAnchor(), bottom: self.view.safeBottomAnchor(), right: self.view.safeRightAnchor(), paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let xib = UINib(nibName: "NewConversationCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: NewConversationCell.identifier)
        
        tableView.isHidden = true
        
        searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 21.0))
        searchTextField.placeholder = "Search"
        searchTextField.delegate = self
        
        btnSetting = UIBarButtonItem(image: #imageLiteral(resourceName: "Setting"), style: .plain, target: self, action: #selector(self.clickedSetting))
        btnSearch = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(self.clickedSearch))
        
        self.navigationItem.rightBarButtonItem = btnSetting
        self.navigationItem.leftBarButtonItem = btnSearch
        
        btnClose = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(self.clickedClose))
        
        self.view.addSubview(btnBlock)
        self.view.bringSubviewToFront(btnBlock)
        btnBlock.anchor(top: profileView.safeTopAnchor(), left: nil, bottom: profileView.safeBottomAnchor(), right: profileView.safeRightAnchor(), paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 24, height: 24)
        btnBlock.addTarget(self, action: #selector(clickedBlock), for: .touchUpInside)
        btnBlock.isHidden = true
        
        self.view.addSubview(btnChat)
        self.view.bringSubviewToFront(btnChat)
        btnChat.anchor(top: profileView.safeTopAnchor(), left: nil, bottom: profileView.safeBottomAnchor(), right: btnBlock.safeLeftAnchor(), paddingTop: 32, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 24, height: 24)
        btnChat.addTarget(self, action: #selector(clickedChat), for: .touchUpInside)
        btnChat.isHidden = true
        
        self.navigationItem.rightBarButtonItem = btnSetting

        tutorialPositions = [
            CGPoint(x: levelNumberView.center.x, y: levelView.center.y + 100),
            CGPoint(x: coinView.center.x, y: coinView.center.y + 100),
            CGPoint(x: statisticsView.center.x, y: statisticsView.center.y),
            CGPoint(x: 32, y: barHeight + navHeight)
        ]
        
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
            UserData.shared().setFirstTimeUsage(screen: "profile")
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
        guard let userInfo = notification.userInfo, let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
    }
    
    public func updateUser() {
        
        if let avatar = user.avatar {
            FSWrapper.wrapper.loadImage(url: URL(string: avatar)!, completion: { (image, error) in
                self.avatarView.image = image
            })
        }  else {
            avatarView.image = UIImage(named: "AvatarPlaceholder")
        }
        
        nameView.text = user.name
        
    }
    
    @objc func clickedCoins() {
        
        let statisticsVC = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        statisticsVC.modalPresentationStyle = .overFullScreen
        
        statisticsVC.typeString = "Camp Coins (HOTs)"
        statisticsVC.numberString = coinNumberLabel.text
        statisticsVC.contentString = "Camp Coins (a.k.a HOTs) are Camp's virtual currency. You can earn Camp Coin by downloading the supplementary Camp Wallet app on the app store. Consider your Camp Coin as your ticket into the Camp economy. The more Camp Coin you have, the more features you can access and the better status you will have across both apps."
        statisticsVC.modalPresentationStyle = .overFullScreen
        
        self.navigationController?.tabBarController?.present(statisticsVC, animated: true, completion: nil)
        
    }
    
    @objc func clickedMessageReceived() {
        
        let statisticsVC = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        statisticsVC.modalPresentationStyle = .overFullScreen
        
        statisticsVC.typeString = "Messages Received"
        statisticsVC.numberString = messageReceivedLabel.text
        
        self.navigationController?.tabBarController?.present(statisticsVC, animated: true, completion: nil)
    
    }
    
    @objc func clickedMessageSent() {
        let statisticsVC = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        statisticsVC.modalPresentationStyle = .overFullScreen
        
        statisticsVC.typeString = "Messages Sent"
        statisticsVC.numberString = messageSentLabel.text
        
        self.navigationController?.tabBarController?.present(statisticsVC, animated: true, completion: nil)
    }
    
    @objc func clickedResponseTime() {
        let statisticsVC = StatisticsViewController(nibName: "StatisticsViewController", bundle: nil)
        statisticsVC.modalPresentationStyle = .overFullScreen
        
        statisticsVC.typeString = "Response Time"
        statisticsVC.numberString = responseTimeLabel.text
        
        self.navigationController?.tabBarController?.present(statisticsVC, animated: true, completion: nil)
    }
    
    @objc func clickedSetting() {
        
        let settingVC = SettingViewController(nibName: "SettingViewController", bundle: nil)
        settingVC.title = "Settings"
        self.navigationController?.pushViewController(settingVC, animated: true)
        
    }
    
    @objc func clickedSearch() {
        
        tableView.isHidden = false
        btnChat.isHidden = true
        btnBlock.isHidden = true
        isSearching = true
        self.navigationItem.titleView = searchTextField
        self.navigationItem.rightBarButtonItem = btnClose
        
        searchTextField.becomeFirstResponder()
        
    }
    
    @objc func clickedClose() {
                
        tableView.isHidden = true
        isSearching = false
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        
        self.navigationItem.titleView = titleView
        self.navigationItem.rightBarButtonItem = btnSetting
        
    }
    
    @objc func clickedChat() {
        

    }
    
    @objc func clickedBlock() {
        
    }
    
}

extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return true
    }
    
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationCell.identifier, for: indexPath) as! NewConversationCell
        
        let user = users[indexPath.row]
        cell.nameView.text = user.name
        if let avatar = user.avatar {
            FSWrapper.wrapper.loadImage(url: URL(string: avatar)!, completion: { (image, error) in
                cell.avatar.image = image
            })
        }  else {
            cell.avatar.image = UIImage(named: "AvatarPlaceholder")
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // FLOW: Update UI with user stuff
        let user = self.users[indexPath.row]
        
        self.user = user
        updateUser()
        
        clickedClose()
        
    }
}
