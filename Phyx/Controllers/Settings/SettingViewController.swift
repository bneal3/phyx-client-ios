//
//  SettingViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var btnBack: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    private func initialize() {
        
        let image = UIImage(named: "BackBlack")
        
        btnBack = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = btnBack
        
        self.title = "Settings"
        
        let xib = UINib(nibName: SettingCell.identifier, bundle: nil)
        self.tableView.register(xib, forCellReuseIdentifier: SettingCell.identifier)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    @objc func clickedBack() {
        
        self.navigationController?.popViewController(animated: true)
        
    }

}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.identifier, for: indexPath) as! SettingCell
        if indexPath.row == -2 {
            cell.configureCell(text: "Notifications", sw: true)
        }
        
        if indexPath.row == 0 {
            cell.configureCell(text: "Edit Profile", sw: false)
            cell.accessoryType = .disclosureIndicator
        }
        
        if indexPath.row == 1 {
            cell.configureCell(text: "Change Password", sw: false)
            cell.accessoryType = .disclosureIndicator
        }
        
        if indexPath.row == 2 {
            cell.configureCell(text: "Give Us Feedback", sw: false)
            cell.accessoryType = .disclosureIndicator
        }
        
        if indexPath.row == 3 {
            cell.configureCell(text: "Terms of Service", sw: false)
            cell.accessoryType = .disclosureIndicator
        }
        
        if indexPath.row == 4 {
            cell.configureCell(text: "Log Out", sw: false)
        }
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == -2 {
            
        }
        
        if indexPath.row == 0 {
            
            let editProfileVC = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
            let nav = UINavigationController(rootViewController: editProfileVC)
            self.navigationController?.tabBarController?.present(nav, animated: true, completion: nil)
            
        }
        
        if indexPath.row == 1 {
            
            let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
            let nav = UINavigationController(rootViewController: changePasswordVC)
            self.navigationController?.tabBarController?.present(nav, animated: true, completion: nil)
            
        }
        
        if indexPath.row == 2 {
            
            let giveVC = GiveFeedBackViewController(nibName: "GiveFeedBackViewController", bundle: nil)
            let nav = UINavigationController(rootViewController: giveVC)
            self.navigationController?.tabBarController?.present(nav, animated: true, completion: nil)
            
        }
        
        if indexPath.row == 3 {
            
            let termsVC = TermsViewController(nibName: "TermsViewController", bundle: nil)
            let nav = UINavigationController(rootViewController: termsVC)
            self.navigationController?.tabBarController?.present(nav, animated: true, completion: nil)
            
        }
        
        if indexPath.row == 4 {
            
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
    
}
