
//
//  PurchaseSuccessViewController.swift
//  Camp
//
//  Created by sonnaris on 9/2/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class PurchaseSuccessViewController: UIViewController {

    var contentString: String!
    @IBOutlet weak var contentLabel: UILabel!
    
    var delegate: ModalHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    private func initialize() {
        
        
        
    }
    
    @IBAction func clickedGotIt(_ sender: Any) {
        
        self.dismiss(animated: false) {
            self.delegate.modalDismissed()
        }
        
    }
    
}
