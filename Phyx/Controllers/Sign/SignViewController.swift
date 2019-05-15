//
//  SignViewController.swift
//  Phyx
//
//  Created by sonnaris on 8/15/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SwiftyAvatar
import SVProgressHUD
import SDWebImage

class SignViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    
    @IBOutlet weak var passwordCheck: UIImageView!
    @IBOutlet weak var confirmCheck: UIImageView!
    
    @IBOutlet weak var avatar: SwiftyAvatar!
    
    @IBOutlet weak var termsLabel: UILabel!
    // Camera connection
    private var cameraController: CMCameraVC! = CMCameraVC()
    private var selectedMedia: UIImage? = nil
    
    var phone: String?
    
    private let formatter : DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private lazy var calendarPopup : CalendarPopUpView = {
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 350)
        let calendar = CalendarPopUpView(frame: frame)
        calendar.center = view.center
        calendar.backgroundColor = .clear
        calendar.layer.shadowColor = UIColor.black.cgColor
        calendar.layer.shadowOpacity = 0.4
        calendar.layer.shadowOffset = .zero
        calendar.layer.shadowRadius = 5
        calendar.didSelectDay = {
            self.setSelectedDate()
        }
        return calendar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        
        if let cameraDelegate = cameraController.cameraDelegate {
            if let selectedImage = cameraDelegate.selectedImage {
                self.selectedMedia = selectedImage
                avatar.image = selectedImage
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    private func initialize() {
        
        nameField.delegate = self
        passwordField.delegate = self
        confirmField.delegate = self
        birthField.delegate = self
        
        confirmCheck.isHidden = true
        passwordCheck.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickedAvatar))
        avatar.addGestureRecognizer(tapGesture)
        
        let tapGestureBirth = UITapGestureRecognizer(target: self, action: #selector(self.clickedBirth))
        birthField.addGestureRecognizer(tapGestureBirth)
        birthField.isUserInteractionEnabled = true
        
        let tapGestureView = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        
        self.parentView.addGestureRecognizer(tapGestureView)
        self.confirmField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        self.nameField.becomeFirstResponder()
        nameField.tag = 1
        passwordField.tag = 2
        confirmField.tag = 3
        
        calendarPopup.selectButton.addTarget(self, action: #selector(setSelectedDate), for: .touchUpInside)
        
        termsLabel.text = "By signing up, you agree to the Terms of Service"
        
        let tapGestureTerms = UITapGestureRecognizer(target: self, action: #selector(clickedTerms))
        termsLabel.addGestureRecognizer(tapGestureTerms)
    }
    
    @objc func didTapView() {
        
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let p = passwordField.text
        let c = confirmField.text
        
        if p == c {
            
            passwordCheck.isHidden = false
            confirmCheck.isHidden = false
            
        } else {
            
            passwordCheck.isHidden = true
            confirmCheck.isHidden = true
            
        }
    }
    
    @objc func clickedBirth() {
        
        view.addSubview(calendarPopup)
        calendarPopup.anchor(top: nil, left: view.safeLeftAnchor(), bottom: birthField.safeTopAnchor(), right: view.safeRightAnchor(), paddingTop: 0, paddingLeft: 32, paddingBottom: 0, paddingRight: 32, width: 0, height: 350)
    }
    
    @objc func setSelectedDate() {
        birthField.text = formatter.string(from: calendarPopup.birthdayPicker.date)
        calendarPopup.removeFromSuperview()
    }
    
    @objc func clickedAvatar() {
        
        cameraController.cameraDelegate = nil
        present(cameraController, animated: true, completion: nil)
        
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let camera = UIAlertAction(title: "Camera", style: .default, handler: {action in
//            self.getPhotoFromCamera()
//        })
//        let cameraRoll = UIAlertAction(title: "Camera Roll", style: .default, handler: { action in
//            self.getPhotoFromRoll()
//        })
//        
//        actionSheet.addAction(camera)
//        actionSheet.addAction(cameraRoll)
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func clickedBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickedTerms() {
        
        let termsVC = TermsViewController(nibName: "TermsViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: termsVC)
        self.navigationController?.present(nav, animated: true, completion: nil)
        
    }
    
    @IBAction func clickedSign(_ sender: Any) {
        
        if (nameField.text?.isEmpty)! {
            return
        }
        
        if (passwordField.text?.isEmpty)! || (passwordField.text?.count)! < 6 {
            
            let alert = UIAlertController(title: "Error", message: "Password must be more than six characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        if (confirmField.text?.isEmpty)! {
            return
        }
        
        if (birthField.text?.isEmpty)! {
            return
        }
        
        if passwordField.text != confirmField.text {
            
            let alert = UIAlertController(title: "Error", message: "Password doesn't match.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        signup()
        
    }
    
    private func getPhotoFromCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func getPhotoFromRoll() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    private func signup() {
        
        let name = nameField.text
        let password = passwordField.text
        let birth = birthField.text
        let date = formatter.date(from: birth!)
        let timestamp = date?.timeIntervalSince1970
        let birthday = Int64(timestamp!)

        SVProgressHUD.show()
        
        self.register(phone: phone!, name: name!, password: password!, birth: birthday)
        
    }
    
    func register(phone: String, name: String, password: String, birth: Int64) {
        
        // FLOW: Register user on API
        ApiService.shared().registerUser(phone: phone, name: name, password: password, birth: birth, onSuccess: { result in
            
            // FLOW: Send avatar to Firebase
            if let media = self.selectedMedia {
                let setDate = Date()
                let path = "\(result.id)/\(setDate.toMillis()!)"
                let data = media.jpegData(compressionQuality: 0.1)
                let reference = FSWrapper.wrapper.AVATAR_REF.child(path)
                
                // FLOW: Upload picture
                reference.putData(data!, metadata: nil, completion: { (meta, error) in
                    
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        SVProgressHUD.dismiss()
                        return
                    }
                    
                    reference.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            SVProgressHUD.dismiss()
                            return
                        }
                        
                        // FLOW: Save image to cache
                        SDImageCache.shared().store(media, imageData: nil, forKey: downloadURL.absoluteString, toDisk: false, completion: {})
                        
                        result.avatar = downloadURL.absoluteString
                        UserData.shared().setAvatar(avatar: result.avatar!)
                        
                        // FLOW: Call update user API
                        ApiService.shared().updateProfile(phone: result.phone, name: result.name, avatar: result.avatar!, onSuccess: { (user) in
                            
                            self.completeRegistration(user: result, password: password)

                        }, onFailure: { (error) in
                            print(error)
                            SVProgressHUD.dismiss()
                        })
  
                    }
                    
                })
                
            } else {
                
                self.completeRegistration(user: result, password: password)
                
            }

        }, onFailure: { result in
            
            SVProgressHUD.dismiss()
            
        })
        
    }
    
    func completeRegistration(user: User, password: String) {
        
        SVProgressHUD.dismiss()
        
//        let locationManager = LocationManager.sharedInstance
//        locationManager.showVerboseMessage = true
//        locationManager.autoUpdate = false
//        locationManager.startUpdatingLocation()
        
        // FLOW: Continue to MainViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setMainScreen()

    }
    
}

extension SignViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[] as! UIImage
//        avatar.image = image
//
//        dismiss(animated: true, completion: nil)
//    }
}

extension SignViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let tag = textField.tag
        switch tag {
        case 1:
            passwordField.becomeFirstResponder()
            break
        case 2:
            confirmField.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
            break
        }
        
        return true
    }
    
}

extension SignViewController {

    func addObservers() {
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func removeObservers() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: Notification) {
        
        scrollView.contentInset = .zero
    }
}
