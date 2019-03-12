//
//  PurchaseViewController.swift
//  Camp
//
//  Created by sonnaris on 8/20/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

protocol ModalHandler {
    func modalDismissed()
}

class PurchaseViewController: UIViewController, ModalHandler {
    
    @IBOutlet weak var introductionView: UIImageView!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var descriptionView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    var btnClose : UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        
    }

    private func initialize() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        btnClose = UIBarButtonItem(image: UIImage(named: "Close"), style: .plain, target: self, action: #selector(self.clickedClose))
        self.navigationItem.rightBarButtonItem = btnClose
        
        introductionView.layer.cornerRadius = 3
        introductionView.layer.borderColor = UIColor.init(red: 237.0/255, green: 236.0/255, blue: 236.0/255, alpha: 1.0).cgColor
        introductionView.layer.borderWidth = 0.5
        
        indicatorView.layer.cornerRadius = 7.5
        
    }

    @objc func clickedClose() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickedPurchase(_ sender: Any) {
        
        let purchaseSuccessVC = PurchaseSuccessViewController(nibName: "PurchaseSuccessViewController", bundle: nil)
        purchaseSuccessVC.modalPresentationStyle = .overFullScreen
        purchaseSuccessVC.delegate = self
        self.navigationController?.present(purchaseSuccessVC, animated: false, completion: nil)
    }
    
    
    func modalDismissed() {
        self.navigationController?.dismiss(animated: false, completion: nil)
    }
    
}
