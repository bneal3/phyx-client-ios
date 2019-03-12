//
//  SettingCell.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    
    static let identifier = "SettingCell"
    
    @IBOutlet weak var textView: UILabel!
    
    @IBOutlet weak var swt: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        // Configure the view for the selected state
    }
    
    public func configureCell(text: String, sw: Bool) {
        
        self.textView.text = text

        if sw {
            self.swt.isHidden = false
            self.swt.addTarget(self, action: #selector(handleToggle), for: .touchUpInside)
        } else {
            self.swt.isHidden = true
        }
    }
    
    @objc func handleToggle() {
        let alert = UIAlertController(title: "Notifications", message: "Toggle notifications in Phone Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
        }))
        
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        if let unwrappedAppdelegate = appDelegate {
            unwrappedAppdelegate.window!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
}
