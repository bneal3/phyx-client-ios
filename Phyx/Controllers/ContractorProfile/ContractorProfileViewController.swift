//
//  ProfileViewController.swift
//  Phyx
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import Popover
import SwiftyAvatar
import AVKit
import RealmSwift

class ContractorProfileViewController: UIViewController {
    
    var contractor: Contractor!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var levelView: UIView!
    
    @IBOutlet weak var avatarView: SwiftyAvatar!
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var userNameView: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.navigationController?.isNavigationBarHidden = true
        
        setupContractor()
    }
    
    private func initialize() {
        
        self.levelView.layer.cornerRadius = 3
        
        let path = UIBezierPath(rect: self.levelView.bounds)
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = 2
        border.fillColor = UIColor.clear.cgColor
        self.levelView.layer.addSublayer(border)
        
        self.navigationItem.title = "Contractor"
        
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(clickedVideo))
        videoThumbnail.addGestureRecognizer(videoTap)

        // Bar buttons
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.leftBarButtonItem = btnBack
        
    }
    
    private func setupContractor() {
        
        if let avatar = contractor.avatar, avatar != "" {
            FSWrapper.wrapper.loadImage(url: URL(string: avatar)!, completion: { (image, error) in
                self.avatarView.image = image
            })
        } else {
            avatarView.image = UIImage(named: "AvatarPlaceholder")
        }
        
        nameView.text = contractor.first + " " + contractor.last
        var profession = "Chiropractor"
        let service = AppointmentData.shared().getService()
        if service > 1, service < 8 {
            profession = "Message Therapist"
        } else if service == 8 {
            profession = "Acupuncturist"
        } else if service == 9 {
            profession = "Physical Therapist"
        }
        userNameView.text = profession
        
        bioLabel.text = contractor.bio
        videoThumbnail.image = UIImage(named: "icons8-video-100")
        
        if let video = contractor.video {
            let url = URL(fileURLWithPath: video)
            FSWrapper.wrapper.download(url: url) { (status, url) in
                if let url = url {
                    self.videoURL = url
                }
            }
        }
    
        if let rating = contractor.rating {
            ratingLabel.text = String(Double((rating * 100) / 100).rounded(toPlaces: 1))
        }
    }
    
    @objc func clickedVideo() {
        if let video = videoURL {
            let player = AVPlayer(url: video)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        } else {
            // TODO: Alert that there is no video
        }
    }

    
    @objc func clickedBack() {
        
        self.navigationController?.popViewController(animated: true)
        
    }

//    @IBAction func selectTapped(_ sender: Any) {
//        AppointmentData.shared().setContractorId(contractorId: contractor.id)
//        AppointmentData.shared().setStatus(status: 1)
//
//        let confirmationVC = AppointmentConfirmationViewController(nibName: "AppointmentConfirmationViewController", bundle: nil)
//        self.navigationController?.pushViewController(confirmationVC, animated: true)
//    }
//    
//    @IBAction func passTapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//
//    }
}

