//
//  ContactViewController.swift
//  Phyx
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

class AppointmentListViewController: UIViewController {

    var btnMenu: UIBarButtonItem!
    var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
    
    var appointments: [Appointment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Appointments"
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        initialize()
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
        
        let listXib = UINib(nibName: "AppointmentListCell", bundle: nil)
        tableView.register(listXib, forCellReuseIdentifier: AppointmentListCell.identifier)
        
        btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: .plain, target: self, action: #selector(self.clickedBack))
        
        self.navigationItem.leftBarButtonItem = btnBack
     
        loadAppointments()
    }
    
    func loadAppointments() {
        SVProgressHUD.show()
        ApiService.shared().getAppointments(onSuccess: { (appointments) in
            SVProgressHUD.dismiss()
            self.appointments = appointments.sorted(by: {
                return $0.meetingTime > $1.meetingTime
            })
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.dismiss()
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
    
    @objc func clickedBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AppointmentListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentListCell.identifier, for: indexPath) as! AppointmentListCell
        
        cell.setCell(appointment: appointments[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let sessionVC = SessionViewController(nibName: "SessionViewController", bundle: nil)
        sessionVC.appointment = appointments[indexPath.row]
        self.navigationController?.pushViewController(sessionVC, animated: true)
               
    }
    
}
