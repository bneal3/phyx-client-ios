//
//  AlertManager.swift
//  Camp
//
//  Created by Benjamin Neal on 2/4/19.
//  Copyright © 2019 sonnaris. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    private static var sharedAlertManager: AlertManager = {
        return AlertManager()
    }()
    
    class func shared() -> AlertManager {
        return sharedAlertManager
    }
    
    func error(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let unwrappedAppdelegate = appDelegate {
            unwrappedAppdelegate.window!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
}

