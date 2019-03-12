//
//  StatisticsViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    var typeString: String!
    var contentString: String!
    var numberString: String!
    var image: UIImage?
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var statImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    private func initialize() {
        
        self.typeLabel.text = typeString
        self.numberLabel.text = numberString
        self.contentLabel.text = contentString
        if let image = image {
            self.statImage.image = image
            self.statImage.layer.cornerRadius = self.statImage.frame.width / 2
            self.statImage.clipsToBounds = true
        }
    }
    
    @IBAction func clickedClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
