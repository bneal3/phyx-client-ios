//
//  MetricsViewController.swift
//  Phyx
//
//  Created by Lee on 1/4/19.
//  Copyright © 2019 sonnaris. All rights reserved.
//

import UIKit
import Stripe

class RateViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var contractorLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var startedLabel: UILabel!
    @IBOutlet weak var endedLabel: UILabel!
    
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    
    @IBOutlet weak var tipField: UITextField!
    
    var stars: [UIButton] = []
    var appointment: Appointment!
    var contractor: Contractor!
    var amount: Int!
    
    var closeBlock: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if let rating = appointment.rating, rating > 0 {
            starTapped(rating, update: false)
        } else {
            starReset()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adjust height and width of dialog
        view.bounds.size.height = containerView.frame.height//UIScreen.main.bounds.size.height * 0.75
        view.bounds.size.width = containerView.frame.width//UIScreen.main.bounds.size.width * 0.70
        view.layer.cornerRadius = 5.0
        
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI() {
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        
        stars = [star1, star2, star3, star4, star5]
        
        tipField.keyboardType = .decimalPad
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
                
        serviceLabel.text = SERVICE_TITLES[appointment.service]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d, h:mm a"
        let startTime = Date(timeIntervalSince1970: appointment.startTime!.toTimeInterval())
        startedLabel.text = dateFormatter.string(from: startTime)
        
        let endTime = Date(timeIntervalSince1970: appointment.endTime!.toTimeInterval())
        endedLabel.text = dateFormatter.string(from: endTime)
        
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
        
        if let avatar = contractor.avatar, avatar != "" {
            FSWrapper.wrapper.loadImage(url: URL(string: avatar)!, completion: { (image, error) in
                self.avatarImage.image = image
            })
        } else {
            avatarImage.image = UIImage(named: "AvatarPlaceholder")
        }
        contractorLabel.text = contractor.first + " " + contractor.last
        var profession = "Chiropractor"
        if appointment.service > 1, appointment.service < 8 {
            profession = "Massage Therapist"
        } else if appointment.service == 8 {
            profession = "Acupuncturist"
        } else if appointment.service == 9 {
            profession = "Message Therapist"
        }
        professionLabel.text = profession
        
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        if (closeBlock != nil) {
            closeBlock!()
        }
    }
    
    func starReset() {
        for i in 0..<stars.count {
            stars[i].setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    func starTapped(_ number: Int, update: Bool) {
        starReset()
        for i in 0..<number {
            stars[i].setImage(UIImage(named: "star-filled"), for: .normal)
        }
        
        if update {
            ApiService.shared().patchAppointment(id: appointment.id, service: appointment.service, meetingTime: appointment.meetingTime, status: appointment.status, location: appointment.location, length: appointment.length, notes: appointment.notes ?? "", rating: number, onSuccess: { (appointment) in
                
                if (self.closeBlock != nil) {
                    self.closeBlock!()
                }
                
            }) { (response) in }
        }
    }
    
    @IBAction func star1Tapped(_ sender: Any) {
        starTapped(1, update: true)
    }
    
    @IBAction func star2Tapped(_ sender: Any) {
        starTapped(2, update: true)
    }
    
    @IBAction func star3Tapped(_ sender: Any) {
        starTapped(3, update: true)
    }
    
    @IBAction func star4Tapped(_ sender: Any) {
        starTapped(4, update: true)
    }
    
    @IBAction func star5Tapped(_ sender: Any) {
        starTapped(5, update: true)
    }
    
    @IBAction func tipTapped(_ sender: Any) {
        if let tip = tipField.text, let amount = Float(tip) {
            print(amount)
            self.amount = Int(amount * 100)
            handleAddPaymentOptionButtonTapped()
        }
    }
    
}

extension RateViewController {
    
    func handleAddPaymentOptionButtonTapped() {
        // Setup add card view controller
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
        // Present add card view controller
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        ApiService.shared().tip(token: token.tokenId, amount: self.amount, meetingTime: appointment.meetingTime, appointmentId: appointment.id, onSuccess: { (response) in
            
            let alert = UIAlertController(title: "Your payment was successful",
                                          message: "Thank you for showing your appreciation.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: {})
            }))
            self.present(alert, animated: true, completion: nil)
            
        }) { (error) in
            let alert = UIAlertController(title: "Your order was not successful",
                                          message: "Please try again.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: {})
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
