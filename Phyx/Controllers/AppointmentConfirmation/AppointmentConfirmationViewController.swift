//
//  ProfileViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import Popover
import SwiftyAvatar
import RealmSwift
import SquareInAppPaymentsSDK
import Stripe

enum Result<T> {
    case success
    case failure(T)
    case canceled
}

class AppointmentConfirmationViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var levelView: UIView!
    
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var removeTimeBtn: UIButton!
    @IBOutlet weak var addTimeBtn: UIButton!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var costLabel: UILabel!
    
    var paymentSucceeded: Bool!
    var amount: Int! = 100
    
    var  notesPlaceholder = "Anything you want the contractor to know."
    
    // fileprivate var applePayResult: Result<String> = Result.canceled
    
    var customerContext: STPCustomerContext!
    var paymentContext: STPPaymentContext!
    
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
        
        self.levelView.layer.cornerRadius = 3
        
        let path = UIBezierPath(rect: self.levelView.bounds)
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = 2
        border.fillColor = UIColor.clear.cgColor
        self.levelView.layer.addSublayer(border)
        
        self.navigationItem.title = "Appointment Confirmation"
        
        notesTextView.layer.borderWidth = 1
        notesTextView.layer.borderColor = UIColor(netHex: 0xA9A9A9).cgColor
        notesTextView.delegate = self
        
        notesTextView.text = notesPlaceholder
        notesTextView.textColor = UIColor.phyx
        notesTextView.selectedTextRange = notesTextView.textRange(from: notesTextView.beginningOfDocument, to: notesTextView.beginningOfDocument)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOut))
        view.addGestureRecognizer(tapGesture)

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
        
        let appointment = AppointmentData.shared().getAppointment()
        
        serviceLabel.text = SERVICE_TITLES[appointment.service]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let meetingTime = Date(timeIntervalSince1970: appointment.meetingTime.toTimeInterval())
        dateLabel.text = dateFormatter.string(from: meetingTime)
        
        addressLabel.text = appointment.location
        
        if appointment.service > 1, appointment.service < 8 {
            AppointmentData.shared().setLength(length: 30)
            lengthLabel.text = "\(String(AppointmentData.shared().getLength()!)) minutes"
            
            addTimeBtn.isHidden = false
        } else {
            addTimeBtn.isHidden = true
            removeTimeBtn.isHidden = true
        }
        
        costLabel.text = "$\(Double(amount / 100).rounded(toPlaces: 2))"
        
    }
    
    @objc func tappedOut() {
        self.view.endEditing(true)
    }
    
    @objc func clickedBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func removeTimeTapped(_ sender: Any) {
        AppointmentData.shared().setLength(length: AppointmentData.shared().getLength()! - 30)
        lengthLabel.text = "\(String(AppointmentData.shared().getLength()!)) minutes"
        
        if AppointmentData.shared().getLength()! == 30 {
            removeTimeBtn.isHidden = true
        }
        
        if AppointmentData.shared().getLength()! < 120 {
            addTimeBtn.isHidden = false
        }
    }
    
    @IBAction func addTimeTapped(_ sender: Any) {
        AppointmentData.shared().setLength(length: AppointmentData.shared().getLength()! + 30)
        lengthLabel.text = "\(String(AppointmentData.shared().getLength()!)) minutes"

        if AppointmentData.shared().getLength()! == 120 {
            addTimeBtn.isHidden = true
        }
        
        if AppointmentData.shared().getLength()! > 30 {
            removeTimeBtn.isHidden = false
        }
    }
    
    @IBAction func passTapped(_ sender: Any) {
        handleAddPaymentOptionButtonTapped()
    }
}


extension AppointmentConfirmationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // TODO: Scroll up
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notesTextView.resignFirstResponder()
        
        return true
    }
    
}

extension AppointmentConfirmationViewController {
    
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
        
        ApiService.shared().charge(token: token.tokenId, amount: amount, category: "initial", meetingTime: AppointmentData.shared().getMeetingTime(), appointmentId: nil, onSuccess: { (response) in
            
            var notes = ""
            if self.notesTextView.text != self.notesPlaceholder {
                notes = self.notesTextView.text
            }
            
        ApiService.shared().postAppointment(service: AppointmentData.shared().getService(), meetingTime: AppointmentData.shared().getMeetingTime(), location: AppointmentData.shared().getLocation(), length: AppointmentData.shared().getLength(), notes: notes, amount: self.amount, chargeId: response.object["chargeId"] as! String, onSuccess: { (appointment) in
                
                RealmService.shared.createIfNotExists(appointment)
                
                self.dismiss(animated: true, completion: {
                    let successVC = PurchaseSuccessViewController(nibName: "PurchaseSuccessViewController", bundle: nil)
                    self.navigationController?.pushViewController(successVC, animated: true)
                })
                
            }) { (response) in
                // TODO: Alert problem creating appointment
                self.dismiss(animated: true, completion: {})
            }
            
        }) { (error) in
            // FLOW: Alert error
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


//extension AppointmentConfirmationViewController {
//    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//
//        ApiService.shared().createKey(apiVersion: apiVersion, onSuccess: { (response) in
//
//            customerContext = STPCustomerContext(keyProvider: response.object["id"] as! String)
//            completion(response.object, nil)
//        }) { (error) in
//            // TODO: Alert
//            completion(nil, error as! Error)
//        }
//    }
//
//    func choosePaymentButtonTapped() {
//        self.paymentContext.pushPaymentOptionsViewController()
//    }
//}
//
//extension AppointmentConfirmationViewController {
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
//        let upsGround = PKShippingMethod()
//        upsGround.amount = 0
//        upsGround.label = "UPS Ground"
//        upsGround.detail = "Arrives in 3-5 days"
//        upsGround.identifier = "ups_ground"
//        let fedEx = PKShippingMethod()
//        fedEx.amount = 5.99
//        fedEx.label = "FedEx"
//        fedEx.detail = "Arrives tomorrow"
//        fedEx.identifier = "fedex"
//
//        if address.country == "US" {
//            completion(.valid, nil, [upsGround, fedEx], upsGround)
//        }
//        else {
//            completion(.invalid, nil, nil, nil)
//        }
//    }
//
//    func paymentContext(_ paymentContext: STPPaymentContext,
//                        didCreatePaymentResult paymentResult: STPPaymentResult,
//                        completion: @escaping STPErrorBlock) {
//
//        ApiService.shared().charge(amount: 100, stripeId: paymentResult.source.stripeID, meetingTime: AppointmentData.shared().getMeetingTime(), description: "initial", onSuccess: { (response) in
//            completion(nil)
//        }, onFailure: { (error) in
//            completion(error as! Error)
//        })
//    }
//
//    func paymentContext(_ paymentContext: STPPaymentContext,
//                        didFinishWith status: STPPaymentStatus,
//                        error: Error?) {
//
//        switch status {
//        case .error:
//            // TODO: Alert
//            print("ERROR")
//        case .success:
//            // TODO: Go to next screen
//            print("SUCCESS")
//        case .userCancellation:
//            return // Do nothing
//        }
//    }
//
//    func paymentContext(_ paymentContext: STPPaymentContext,
//                        didFailToLoadWithError error: Error) {
//        self.navigationController?.popViewController(animated: true)
//        // Show the error to your user, etc.
//    }
//
//    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
//
//    }
//
//}

//extension AppointmentConfirmationViewController {
//    private func showOrderSheet() {
//        // Open the buy modal
//        let orderViewController = OrderViewController()
//        orderViewController.delegate = self
//
//        let nc = OrderNavigationController(rootViewController: orderViewController)
//        nc.modalPresentationStyle = .custom
//        nc.transitioningDelegate = self
//        present(nc, animated: true, completion: nil)
//    }
//
////    private func printCurlCommand(nonce : String) {
////        let uuid = UUID().uuidString
////        print("curl --request POST https://connect.squareup.com/v2/locations/SQUARE_LOCATION_ID/transactions \\" +
////            "--header \"Content-Type: application/json\" \\" +
////            "--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\" +
////            "--header \"Accept: application/json\" \\" +
////            "--data \'{" +
////            "\"idempotency_key\": \"\(uuid)\"," +
////            "\"amount_money\": {" +
////            "\"amount\": 100," +
////            "\"currency\": \"USD\"}," +
////            "\"card_nonce\": \"\(nonce)\"" +
////            "}\'");
////    }
////
////    private var serverHostSet: Bool {
////        return API_URL != "REPLACE_ME"
////    }
////
////    private var appleMerchanIdSet: Bool {
////        return Constants.ApplePay.MERCHANT_IDENTIFIER != "REPLACE_ME"
////    }
//}

//extension AppointmentConfirmationViewController {
//    func makeCardEntryViewController() -> SQIPCardEntryViewController {
//        // Customize the card payment form
//        let theme = SQIPTheme()
//        theme.errorColor = .red
//        theme.tintColor = UIColor.phyx
//        theme.keyboardAppearance = .light
//        theme.messageColor = UIColor.gray
//        theme.saveButtonTitle = "Pay"
//
//        return SQIPCardEntryViewController(theme: theme)
//    }
//}
//
//extension AppointmentConfirmationViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSheetPresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
//
//// MARK: - OrderViewControllerDelegate functions
//extension AppointmentConfirmationViewController: OrderViewControllerDelegate {
//    func didRequestPayWithCard() {
//        dismiss(animated: true) {
//            let vc = self.makeCardEntryViewController()
//            vc.delegate = self
//
//            let nc = UINavigationController(rootViewController: vc)
//            self.present(nc, animated: true, completion: nil)
//        }
//    }
//
//    func didRequestPayWithApplyPay() {
//        dismiss(animated: true) {
//            // self.requestApplePayAuthorization()
//        }
//    }
//
//    private func didNotChargeApplePay(_ error: String) {
//        // Let user know that the charge was not successful
//        let alert = UIAlertController(title: "Your order was not successful",
//                                      message: error,
//                                      preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func didChargeSuccessfully() {
//        ApiService.shared().postAppointment(service: AppointmentData.shared().getService(), meetingTime: AppointmentData.shared().getMeetingTime(), location: AppointmentData.shared().getLocation(), length: AppointmentData.shared().getLength(), notes: self.notesTextView.text, onSuccess: { (appointment) in
//            RealmService.shared.createIfNotExists(appointment)
//            // Let user know that the charge was successful
//            let alert = UIAlertController(title: "Your order was successful",
//                                          message: "Go to your Square dashboard to see this order reflected in the sales tab.",
//                                          preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                // FLOW: Save Appointment to Realm
//                let successVC = PurchaseSuccessViewController(nibName: "PurchaseSuccessViewController", bundle: nil)
//                self.navigationController?.pushViewController(successVC, animated: true)
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }) { (response) in
//            // TODO: Alert problem creating appointment
//            // TODO: Refund
//        }
//    }
//
////    private func showCurlInformation() {
////        let alert = UIAlertController(title: "Nonce generated but not charged",
////                                      message: "Check your console for a CURL command to charge the nonce, or replace Constants.Square.CHARGE_SERVER_HOST with your server host.",
////                                      preferredStyle: UIAlertController.Style.alert)
////        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////        present(alert, animated: true, completion: nil)
////    }
////
////    private func showMerchantIdNotSet() {
////        let alert = UIAlertController(title: "Missing Apple Pay Merchant ID",
////                                      message: "To request an Apple Pay nonce, replace Constants.ApplePay.MERCHANT_IDENTIFIER with a Merchant ID.",
////                                      preferredStyle: UIAlertController.Style.alert)
////        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
////        present(alert, animated: true, completion: nil)
////    }
//}
//
//extension AppointmentConfirmationViewController: SQIPCardEntryViewControllerDelegate {
//    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
//        // Note: If you pushed the card entry form onto an existing navigation controller,
//        // use UINavigationController.popViewController(animated:) instead
//        dismiss(animated: true) {
//            switch status {
//            case .canceled:
//                self.showOrderSheet()
//                break
//            case .success:
//                self.didChargeSuccessfully()
//            }
//        }
//    }
//
//    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
//        // TODO: Change Stripe
//        ChargeApi.processPayment(cardDetails.nonce) { (transactionID, errorDescription) in
//            guard let errorDescription = errorDescription else {
//                // No error occured, we successfully charged
//                completionHandler(nil)
//                return
//            }
//
//            // Pass error description
//            let error = NSError(domain: "com.example.supercookie", code: 0, userInfo:[NSLocalizedDescriptionKey : errorDescription])
//            completionHandler(error)
//        }
//    }
//}

//extension AppointmentConfirmationViewController: PKPaymentAuthorizationViewControllerDelegate {
//    func requestApplePayAuthorization() {
//        guard SQIPInAppPaymentsSDK.canUseApplePay else {
//            return
//        }
//
////        guard appleMerchanIdSet else {
////            showMerchantIdNotSet()
////            return
////        }
//
//        let paymentRequest = PKPaymentRequest.squarePaymentRequest(
//            merchantIdentifier: Constants.ApplePay.MERCHANT_IDENTIFIER,
//            countryCode: Constants.ApplePay.COUNTRY_CODE,
//            currencyCode: Constants.ApplePay.CURRENCY_CODE
//        )
//
//        paymentRequest.paymentSummaryItems = [
//            PKPaymentSummaryItem(label: "Phyx Wellness Service", amount: 1.00)
//        ]
//
//        let paymentAuthorizationViewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
//
//        paymentAuthorizationViewController!.delegate = self
//
//        present(paymentAuthorizationViewController!, animated: true, completion: nil)
//    }
//
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
//                                            didAuthorizePayment payment: PKPayment,
//                                            handler completion: @escaping (PKPaymentAuthorizationResult) -> Void){
//
//        // Turn the response into a nonce, if possible
//        // Nonce is used to actually charge the card on the server-side
//        let nonceRequest = SQIPApplePayNonceRequest(payment: payment)
//
//        nonceRequest.perform { [weak self] cardDetails, error in
//            guard let cardDetails = cardDetails else {
//                let errors = [error].compactMap { $0 }
//                completion(PKPaymentAuthorizationResult(status: .failure, errors: errors))
//                return
//            }
//
//            guard let strongSelf = self else {
//                completion(PKPaymentAuthorizationResult(status: .failure, errors: []))
//                return
//            }
//
////            guard strongSelf.serverHostSet else {
////                strongSelf.printCurlCommand(nonce: cardDetails.nonce)
////                strongSelf.applePayResult = .success
////                completion(PKPaymentAuthorizationResult(status: .failure, errors: []))
////                return
////            }
//
//            ChargeApi.processPayment(cardDetails.nonce) { (transactionId, error) in
//                if let error = error, !error.isEmpty {
//                    strongSelf.applePayResult = Result.failure(error)
//                } else {
//                    strongSelf.applePayResult = Result.success
//                }
//
//                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
//            }
//        }
//    }
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        controller.dismiss(animated: true) {
//            switch self.applePayResult {
//            case .success:
//                self.didChargeSuccessfully()
//            case .failure(let description):
//                self.didNotChargeApplePay(description)
//                break
//            case .canceled:
//                self.showOrderSheet()
//            }
//        }
//    }
//}

