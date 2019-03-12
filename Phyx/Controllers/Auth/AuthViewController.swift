//
//  AuthViewController.swift
//  Camp
//
//  Created by sonnaris on 8/15/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initialize() {
        
    }
    
    @IBAction func clickedSignIn(_ sender: Any) {
        
        let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @IBAction func clickedSignUp(_ sender: Any) {

//        let onboardVC = OnboardViewController(nibName: "OnboardViewController", bundle: nil)
//        self.navigationController?.pushViewController(onboardVC, animated: true)
        
        let verifyVC = VerifyViewController(nibName: "VerifyViewController", bundle: nil)
        self.navigationController?.pushViewController(verifyVC, animated: true)
        
    }
}
