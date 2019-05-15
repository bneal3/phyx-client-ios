//
//  GiveFeedBackViewController.swift
//  Camp
//
//  Created by sonnaris on 8/22/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class GiveFeedBackViewController: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subjectField: UITextField!
    var btnBack : UIBarButtonItem!

    @IBOutlet weak var feedbackField: UITextView!
    @IBOutlet weak var feedbackView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialze()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }

    private func initialze() {
        
        self.title = "Support"
        btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.hidesBackButton = true
        
        self.feedbackView.layer.borderColor = UIColor.init(red: 169.0/255, green: 169.0/255, blue: 169.0/255, alpha: 0.8).cgColor
        self.feedbackView.layer.borderWidth = 0.5
        self.feedbackView.layer.cornerRadius = 3
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapView))
        self.parentView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func didTapView() {
        
        view.endEditing(true)
        
    }
    
    
    @objc func clickedBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedSend(_ sender: Any) {

        if let subject = subjectField.text, let feedback = feedbackField.text {

            ApiService.shared().sendFeedback(subject: subject, feedback: feedback, onSuccess: { result in
                
                let alert = UIAlertController(title: "Feedback", message: "Thanks for your inquiry, we will get back to you shortly.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }, onFailure: {error in
                
                let alert = UIAlertController(title: "Error", message: "Error sending feedback. Try again later.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            })
        }
    }
    
}

extension GiveFeedBackViewController {
    
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
