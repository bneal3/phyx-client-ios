
//
//  PurchaseSuccessViewController.swift
//  Phyx
//
//  Created by sonnaris on 9/2/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class PurchaseSuccessViewController: UIViewController {

    var contentString: String!
    @IBOutlet weak var contentLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    private func initialize() {
        
        self.title = "Appointment Confirmed"
        self.navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func clickedGotIt(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
//        self.dismiss(animated: false) {
//            self.delegate.modalDismissed()
//        }
        
    }
    
}
