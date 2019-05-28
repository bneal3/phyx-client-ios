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
import RealmSwift
import LSDialogViewController
import SVProgressHUD
import Stripe

class SessionViewController: UIViewController, STPAddCardViewControllerDelegate {
        
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addTimeBtn: UIButton!
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var contractorAvatar: UIImageView!
    @IBOutlet weak var contractorLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var statusLabelView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    var appointment: Appointment!
    var contractor: Contractor? = nil
    
    var amount: Int! = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        initialize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.navigationController?.isNavigationBarHidden = true
        
        setupAppointment()
    }
    
    private func initialize() {
        
        self.navigationItem.title = "Session Details"
        
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor(netHex: 0xA9A9A9).cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOut))
        view.addGestureRecognizer(tapGesture)
        
//        let labelTap = UITapGestureRecognizer(target: self, action: #selector(passTapped))
//        statusLabelView.addGestureRecognizer(labelTap)
        
        let phoneTap = UITapGestureRecognizer(target: self, action: #selector(clickedPhone))
        phoneLabel.addGestureRecognizer(phoneTap)
        
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(clickedContractor))
        contractorAvatar.addGestureRecognizer(avatarTap)

        // Bar buttons
        
        let btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.leftBarButtonItem = btnBack
    
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    private func setupAppointment() {
        serviceLabel.text = SERVICE_TITLES[appointment.service]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let meetingTime = Date(timeIntervalSince1970: appointment.meetingTime.toTimeInterval())
        dateLabel.text = dateFormatter.string(from: meetingTime)
        
        addressLabel.text = appointment.location
        
        contractorAvatar.layer.masksToBounds = true
        contractorAvatar.layer.cornerRadius = contractorAvatar.frame.width / 2
        
        if let length = appointment.length {
            self.lengthLabel.text = "\(String(length)) minutes"
            if length >= 120 {
                addTimeBtn.isHidden = true
            }
        } else {
            self.lengthLabel.text = "~\(String(AppointmentData.shared().getLength()!)) minutes"
        }
        
        if let contractorId = appointment.contractorId, contractorId != "" {
            SVProgressHUD.show()
            ApiService.shared().getContractor(id: contractorId, onSuccess: { (contractor) in
                SVProgressHUD.dismiss()
                self.contractor = contractor
                
                if let avatar = contractor.avatar, avatar != "" {
                    FSWrapper.wrapper.loadImage(url: URL(string: avatar)!, completion: { (image, error) in
                        self.contractorAvatar.image = image
                    })
                } else {
                    self.contractorAvatar.image = UIImage(named: "AvatarPlaceholder")
                }
                self.contractorLabel.text = contractor.first + " " + contractor.last
                var profession = "Chiropractor"
                if self.appointment.service > 1, self.appointment.service < 8 {
                    profession = "Massage Therapist"
                } else if self.appointment.service == 8 {
                    profession = "Acupuncturist"
                } else if self.appointment.service == 9 {
                    profession = "Physical Therapist"
                }
                self.professionLabel.text = profession
                self.phoneLabel.text = contractor.phone
            }) { (response) in
                SVProgressHUD.dismiss()
            }
        } else {
            self.contractorAvatar.image = UIImage(named: "AvatarPlaceholder")
            self.contractorLabel.text = "Contractor Requested"
            self.professionLabel.text = ""
            self.phoneLabel.text = ""
        }

        if let notes = appointment.notes {
            notesTextView.text = notes
        }
        
        if appointment.service > 1, appointment.service < 8 {
            addTimeBtn.isHidden = false
        } else {
            addTimeBtn.isHidden = true
        }
        
        if appointment.status >= 0 {
            if appointment.status == 4 {
                rateBtn.isHidden = false
            } else {
                rateBtn.isHidden = true
            }
            statusLabel.text = APPOINTMENT_STATUS[appointment.status]
        } else {
            statusLabel.text = "Cancelled"
            cancelBtn.isHidden = true
            addTimeBtn.isHidden = true
        }
    }
    
    @objc func tappedOut() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func clickedBack() {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @objc func clickedContractor() {
        if let contractor = contractor {
            let confirmationVC = ContractorProfileViewController(nibName: "ContractorSelectionViewController", bundle: nil)
            confirmationVC.contractor = contractor
            self.navigationController?.pushViewController(confirmationVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Job Not Accepted",
                                          message: "You will be notified when a contractor accepts your job.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addTimeTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add 30 minutes to the appointment?",
                                      message: "You will be charged an extra $1.00",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.handleAddPaymentOptionButtonTapped()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func clickedPhone() {
        
        guard let number = URL(string: "tel://" + phoneLabel.text!) else { return }
        UIApplication.shared.open(number)
        
    }
    
    @IBAction func clickedRate(_ sender: Any) {
        let dialogViewController = RateViewController(nibName: "RateViewController", bundle: nil)
        dialogViewController.appointment = appointment
        dialogViewController.contractor = contractor
        
        dialogViewController.closeBlock = {
            self.dismissDialogViewController(LSAnimationPattern.fadeInOut)
            self.navigationController?.popToRootViewController(animated: true)
        }
        presentDialogViewController(dialogViewController, animationPattern: LSAnimationPattern.fadeInOut)
    }
    
    @IBAction func clickedCancel(_ sender: Any) {
        var message = "You will be refunded."
        
        if appointment.status >= 2 {
            message = "You will not be refunded."
        }
        
        let alert = UIAlertController(title: "Are you sure you want to cancel?",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            ApiService.shared().patchAppointment(id: self.appointment.id, service: self.appointment.service, meetingTime: self.appointment.meetingTime, status: -1, location: self.appointment.location, length: self.appointment.length, notes: self.appointment.notes ?? "", rating: self.appointment.rating, onSuccess: { (appointment) in
                
                let alert = UIAlertController(title: "Successfully cancelled appointment",
                                              message: "Please contact us if further assistance is needed.",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }, onFailure: { (response) in })
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
//    @objc func passTapped() {
//        let status = appointment.status + 1
//        if status < APPOINTMENT_STATUS.count {
//            statusLabel.text = APPOINTMENT_STATUS[appointment.status + 1]
//        }
//    }

}

extension SessionViewController {
    
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
        
        ApiService.shared().charge(token: token.tokenId, amount: self.amount, category: "additional", meetingTime: self.appointment.meetingTime, appointmentId: self.appointment.id, onSuccess: { (response) in
            
            ApiService.shared().patchAppointment(id: self.appointment.id, service: self.appointment.service, meetingTime: self.appointment.meetingTime, status: self.appointment.status, location: self.appointment.location, length: self.appointment.length! + 30, notes: self.appointment.notes ?? "", rating: self.appointment.rating, onSuccess: { (updated) in
                
                self.dismiss(animated: true, completion: {
                    self.lengthLabel.text = "\(String(updated.length!)) minutes"
                    
                    if updated.length! == 120 {
                        self.addTimeBtn.isHidden = true
                    }
                    
                    let alert = UIAlertController(title: "Time successfully added.",
                                                  message: "Your contractor has been notified.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                    self.present(alert, animated: true, completion: nil)
                })
            }) { (response) in }
        }) { (response) in }
    }
}
