//
//  EditProfileViewController.swift
//  Camp
//
//  Created by sonnaris on 8/22/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SwiftyAvatar
import SVProgressHUD
import FirebaseStorage
import SDWebImage

class EditProfileViewController: UIViewController {
    
    var btnBack : UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var birthField: UITextField!
    @IBOutlet weak var avatar: SwiftyAvatar!
    @IBOutlet weak var birthView: UIView!
    
    // Camera connection
    private var cameraController: CMCameraVC! = CMCameraVC()
    private var selectedMedia: UIImage? = nil
    
    private let formatter : DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
        
    }()
    
//    private lazy var calendarPopup : CalendarPopUpView = {
//
//        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 350)
//        let calendar = CalendarPopUpView(frame: frame)
//        calendar.center = view.center
//        calendar.backgroundColor = .clear
//        calendar.layer.shadowColor = UIColor.black.cgColor
//        calendar.layer.shadowOpacity = 0.4
//        calendar.layer.shadowOffset = .zero
//        calendar.layer.shadowRadius = 5
//        calendar.didSelectDay = {[weak self] date in
//            self?.setSelectedDate(date)
//        }
//        return calendar
//    }()
    

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
        
        self.title = "Edit Profile"
        btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.hidesBackButton = true
        
        self.nameField.delegate = self
        self.usernameField.delegate = self
        self.birthField.isUserInteractionEnabled = false
        
        let birthGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickedBirth))
        self.birthView.addGestureRecognizer(birthGesture)
        
        let avatarGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickedAvatar))
        self.avatar.addGestureRecognizer(avatarGesture)
        self.avatar.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        self.parentView.addGestureRecognizer(tapGesture)
        
        fillData()
        
    }
    
    private func fillData() {
        
        nameField.text = UserData.shared().getUserPersonalName()
        
        usernameField.text = UserData.shared().getPhone()
        usernameField.isEnabled = false
        
        let dateString = formatter.string(from: Date(timeIntervalSince1970: Double(UserData.shared().getUserBirthday())))
        birthField.text = dateString
        
        if let avatar = UserData.shared().getAvatar() {
            FSWrapper.wrapper.loadImage(url: URL(string: avatar)!, completion: { (image, error) in
                self.avatar.image = image
            })
        }
    }
    
    @objc func didTapView() {
        view.endEditing(true)
    }
    
    @objc func clickedBirth() {
        
        // view.addSubview(calendarPopup)
    }
    
    @objc func clickedBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickedAvatar() {
        
        cameraController.cameraDelegate = nil
        present(cameraController, animated: true, completion: nil)
        
//        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alertVC.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
//            self.getPhotoFromCamera()
//        }))
//
//        alertVC.addAction(UIAlertAction(title: "Camera Roll", style: .default, handler: { action in
//            self.getPhotoFromRoll()
//        }))
//        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//
//        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @IBAction func clickedSave(_ sender: Any) {
        
        if let phone = usernameField.text, let name = nameField.text {
            SVProgressHUD.show()
            
            var avatar = UserData.shared().getAvatar() ?? ""
            // FLOW: Send avatar to Firebase
            if let media = selectedMedia {
                let setDate = Date()
                let path = "\(UserData.shared().getId())/\(setDate.toMillis()!)"
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
                        
                        avatar = downloadURL.absoluteString
                        self.updateProfile(phone: phone, name: name, avatar: avatar)
                    }
                    
                })
            } else {
                updateProfile(phone: phone, name: name, avatar: avatar)
            }
        }
        
    }
    
    func updateProfile(phone: String, name: String, avatar: String) {
        
        ApiService.shared().updateProfile(phone: phone, name: name, avatar: avatar, onSuccess: { result in
            
            SVProgressHUD.dismiss()
            
            UserData.shared().setPhone(phone: result.phone)
            UserData.shared().setName(name: result.name)
            
            if let avatar = result.avatar {
                UserData.shared().setAvatar(avatar: avatar)
            }

            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }, onFailure: { error in
            
            SVProgressHUD.dismiss()
            print(error)
            
            AlertManager.shared().error(title: "Error", message: "Could not update profile at this time.")
            
        })
        
    }
    
//    private func setSelectedDate(_ date: Date) {
//        calendarPopup.removeFromSuperview()
//        birthField.text = formatter.string(from: date)
//    }
    
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
    
    
}

extension EditProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
        avatar.image = image
        
        dismiss(animated: true, completion: nil)
        
    }
}

extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension EditProfileViewController {
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
