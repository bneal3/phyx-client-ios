//
//  VerifyViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import InputMask

class VerifyViewController: UIViewController {
    
//    private static let baseURLString = "https://api.authy.com/protected.json"
//    static let path = Bundle.main.path(forResource: "Keys", ofType: "plist")
//    static let keys = NSDictionary(contentsOfFile: path!)
//    static let apiKey = keys!["apiKey"] as! String
    
    @IBOutlet var listener: MaskedTextFieldDelegate!
    @IBOutlet weak var phoneField: UITextField!
    
    var phone: String!
    var lock: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func initialize() {
        
        listener.delegate = self
        phoneField.delegate = listener
        
        listener.affinityCalculationStrategy = .wholeString
        listener.affineFormats = [
            "([000]) [000] - [0000]"
        ]
    }
    
    @IBAction func clickedBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func clickedCode(_ sender: Any) {
                
        if let phone = self.phone {
            
            ApiService.shared().sendCode(phone: phone, onSuccess: { result in
                
                let verifificationVC = VerificationViewController(nibName: "VerificationViewController", bundle: nil)
                verifificationVC.countryCode = "1"
                verifificationVC.phoneNumber = phone
                verifificationVC.lock = self.lock
                
                self.navigationController?.pushViewController(verifificationVC, animated: true)
                
            }, onFailure: { result in })
            
            // VerifyAPI.sendVerificationCode("1", phone)
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            //                let verifyVC = VerificationViewController(nibName: "VerificationViewController", bundle: nil)
            //                verifyVC.countryCode = "1"
            //                verifyVC.phoneNumber = phone
            //                self.navigationController?.pushViewController(verifyVC, animated: true)
            //            })
            
        }
        
    }

}

extension VerifyViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        phoneField.resignFirstResponder()
        return true
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        var newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
//        newString = "(" + newString
//        textField.text = newString
        return true
    }
    
    
}

extension VerifyViewController : MaskedTextFieldDelegateListener {
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        
        self.phone = value
    }
    
}
