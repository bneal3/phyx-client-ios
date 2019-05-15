//
//  LoginViewController.swift
//  Camp
//
//  Created by sonnaris on 8/15/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func initialize() {
        userNameField.delegate =  self
        passwordField.delegate = self
    }
    
    @IBAction func clickedBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func clickedForgot(_ sender: Any) {
        
        let verifyVC = VerifyViewController(nibName: "VerifyViewController", bundle: nil)
        verifyVC.lock = true
        self.navigationController?.pushViewController(verifyVC, animated: true)
        
    }
    
    @IBAction func clickedSign(_ sender: Any) {
        
        if (userNameField.text?.isEmpty)! {
            return
        }
        
        if (passwordField.text?.isEmpty)! {
            return
        }
        
        login()
    }
    
    private func login() {
        
        let username = userNameField.text
        let password = passwordField.text
        
        SVProgressHUD.show()
        
        // FLOW: Login to API
        ApiService.shared().loginUser(identifier: username!, password: password!, onSuccess: {(result) in
                
            SVProgressHUD.dismiss()
        
//            let locationManager = LocationManager.sharedInstance
//            locationManager.showVerboseMessage = true
//            locationManager.autoUpdate = false
//            locationManager.startUpdatingLocation()
            
            // FLOW: Go to main screen
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.setMainScreen()

        }, onFailure: { result in
            
            SVProgressHUD.dismiss()
            AlertManager.shared().error(title: "Error", message: "Problem logging in. Please try again later.")

        })
        
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}
