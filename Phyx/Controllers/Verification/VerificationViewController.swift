//
//  VerificationViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {
    
    var countryCode: String!
    var phoneNumber: String!
    var lock: Bool?

    @IBOutlet weak var code1View: UIView!
    @IBOutlet weak var code2View: UIView!
    @IBOutlet weak var code3View: UIView!
    @IBOutlet weak var code4View: UIView!
    
    @IBOutlet weak var code1Field: UITextField!
    @IBOutlet weak var code2Field: UITextField!
    @IBOutlet weak var code3Field: UITextField!
    @IBOutlet weak var code4Field: UITextField!
    
    @IBOutlet weak var phoneNumberView: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        code1Field.becomeFirstResponder()
    }
    
    private func initialize() {
        
        var phoneString = "+" + String(countryCode) + " (" + phoneNumber[...phoneNumber.index(phoneNumber.startIndex, offsetBy: 2)] + ") "
            + phoneNumber[phoneNumber.index(phoneNumber.startIndex, offsetBy: 3)...phoneNumber.index(phoneNumber.startIndex, offsetBy: 5)]
            + "-"
        phoneString = phoneString + phoneNumber[phoneNumber.index(phoneNumber.startIndex, offsetBy: 6)...phoneNumber.index(phoneNumber.startIndex, offsetBy: 9)]
        phoneNumberView.text = "Please enter the verification code we sent to " + phoneString
        
        code1View.layer.cornerRadius = code1View.frame.size.width / 2
        code2View.layer.cornerRadius = code2View.frame.size.width / 2
        code3View.layer.cornerRadius = code3View.frame.size.width / 2
        code4View.layer.cornerRadius = code4View.frame.size.width / 2
        
        code1View.alpha = 0.4
        code2View.alpha = 0.4
        code3View.alpha = 0.4
        code4View.alpha = 0.4
        
        code1Field.delegate = self
        code2Field.delegate = self
        code3Field.delegate = self
        code4Field.delegate = self
        
        code1Field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        code2Field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        code3Field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        code4Field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func clickedBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let text = textField.text
        if (text?.utf16.count)! >= 1 {
            
            switch textField {
            case code1Field:
                code2Field.becomeFirstResponder()
            case code2Field:
                code3Field.becomeFirstResponder()
            case code3Field:
                code4Field.becomeFirstResponder()
            default:
                break
            }
        }
        
        if textField == code4Field && (text?.utf16.count)! >= 1 {
            
            let code = code1Field.text! + code2Field.text! + code3Field.text! + code4Field.text!
            
            ApiService.shared().verifyCode(code: code, phone: phoneNumber, lock: lock, onSuccess: { result in
                
                if let _ = self.lock {

                    var auth = "x-lock"
                    if _env == Environment.production {
                        auth = "X-Lock"
                    }
    
                    guard let token = result.headers[auth] as? String else {
                        AlertManager.shared().error(title: "Error", message: "Server error. Please try again later.")
                        return
                    }
                    
                    let forgotVC = ForgotPasswordViewController(nibName: "ForgotPasswordViewController", bundle: nil)
                    forgotVC.lockToken = token
                    self.navigationController?.pushViewController(forgotVC, animated: true)
                    
                } else {
    
                    let signVC = SignViewController(nibName: "SignViewController", bundle: nil)
                    signVC.phone = self.phoneNumber
                    
                    self.navigationController?.pushViewController(signVC, animated: true)
                    
                }
                
            }, onFailure: { result in })
            
//            VerifyAPI.validateVerificationCode(countryCode, phoneNumber, string) {
//                checked in
//                if (checked.success) {
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.setMainScreen()
//                } else {
//
//                    let alertController = UIAlertController(title: "Error", message: checked.message, preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//                }
//            }
        }
        
    }
    
    @IBAction func clickedResend(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString : NSString = currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
    }
}
