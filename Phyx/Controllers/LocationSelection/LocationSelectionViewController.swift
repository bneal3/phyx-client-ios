//
//  ContactViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import SVProgressHUD
import Popover
import PubNub
import RealmSwift
import Realm
import MapKit

class LocationSelectionViewController: UIViewController {

    var btnBack : UIBarButtonItem!
    
    var addresses: [MKMapItem] = []

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectBtn: UIButton!
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        initialize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.navigationController?.isNavigationBarHidden = true
        
        self.title = "Choose Location"
        
//        let locationManager = LocationManager.sharedInstance
//        locationManager.showVerboseMessage = true
//        locationManager.autoUpdate = false
//        if locationManager.hasLastKnownLocation {
//            let location = CLLocationCoordinate2D(latitude: locationManager.lastKnownLatitude, longitude: locationManager.lastKnownLongitude)
//            mapView.setCenter(location, animated: false)
//
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = location
//            mapView.addAnnotation(annotation)
//        } else {
//            locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
//                if (error != nil) {
//                    let alert = UIAlertController(title: "Error", message: "Location is not updated, please try again later.", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//
//                let location = CLLocationCoordinate2D(latitude: locationManager.lastKnownLatitude, longitude: locationManager.lastKnownLongitude)
//                self.mapView.setCenter(location, animated: false)
//
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = location
//                self.mapView.addAnnotation(annotation)
//            }
//        }
        print("YO")
        let locationManager = LocationManager.sharedInstance
        locationManager.showVerboseMessage = true
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            
            print("here")
            if (error != nil) {
                self.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.052235
                    , longitude: -118.243683), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)), animated: false)
                return
            }
            
            locationManager.stopUpdatingLocation()
            print(latitude)
            print(longitude)
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.mapView.setCenter(location, animated: false)
            self.zoomMap(byFactor: 0.5)
        }
    }

    private func initialize() {
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let navHeight: CGFloat = self.navigationController!.navigationBar.frame.height

        tableView.delegate = self
        tableView.dataSource = self
        
        let addressXib = UINib(nibName: "AddressCell", bundle: nil)
        tableView.register(addressXib, forCellReuseIdentifier: AddressCell.identifier)
        
        btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = btnBack
        
        searchViewTopConstraint.constant = mapView.frame.height
        searchViewBottomConstraint.constant = -mapView.frame.height
        
        searchField.delegate = self
        
        selectBtn.setTitle("Select", for: .normal)
        selectBtn.isEnabled = false
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        tableView.contentInset = insets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo, let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
    }
    
    func toggleTable() {
        if !isSearching {
            searchViewTopConstraint.constant = 68
            searchViewBottomConstraint.constant = 68
        } else {
            searchField.resignFirstResponder()
            searchViewTopConstraint.constant = mapView.frame.height
            searchViewBottomConstraint.constant = -mapView.frame.height
            isSearching = false
            selectBtn.setTitle("Select", for: .normal)
            selectBtn.isEnabled = false
            mapView.isUserInteractionEnabled = true
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func clickedBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectTapped(_ sender: Any) {
        if !isSearching {
            AppointmentData.shared().setLocation(location: searchField.text!)
            AppointmentData.shared().setStatus(status: 0)
            
//            let contractorData: [String: Any] = [
//                "_id": "124352",
//                "name": "Tim Ursich Jr.",
//                "bio": "I have 10+ years in chiropractic experience and run my own practice in San Pedro.",
//                "services": [0, 1, 2]
//            ]
//            let contractor = Contractor(contractorData: contractorData)
//
//            let confirmationVC = ContractorSelectionViewController(nibName: "ContractorSelectionViewController", bundle: nil)
//            confirmationVC.contractor = contractor
//            self.navigationController?.pushViewController(confirmationVC, animated: true)
            
            let confirmationVC = AppointmentConfirmationViewController(nibName: "AppointmentConfirmationViewController", bundle: nil)
            self.navigationController?.pushViewController(confirmationVC, animated: true)
        } else {
            toggleTable()
        }
    }
    
    func zoomMap(byFactor delta: Double) {
        var region: MKCoordinateRegion = self.mapView.region
        var span: MKCoordinateSpan = mapView.region.span
        span.latitudeDelta = 0.001
        span.longitudeDelta = 0.001
        region.span = span
        mapView.setRegion(region, animated: true)
    }
}

extension LocationSelectionViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        toggleTable()
        isSearching = true
        selectBtn.setTitle("Cancel", for: .normal)
        selectBtn.isEnabled = true
        mapView.isUserInteractionEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let searchText = textField.text else { return false }
        print(searchText)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            let placemark = response.mapItems[0].placemark
            print(placemark.title)
            self.addresses = response.mapItems
            self.tableView.reloadData()
        }
        
        tableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        toggleTable()
        
        return true
        
    }
    
}

extension LocationSelectionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.identifier, for: indexPath) as! AddressCell
        
        cell.setAddress(address: addresses[indexPath.row])
        
        cell.selectionStyle = .none
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Update map, populate search field, allow select
        let item = addresses[indexPath.row]
        let location = item.placemark.coordinate
        let addy = Address(address: item.placemark.title!)
        print("HERE")
        
        mapView.setCenter(location, animated: false)
        zoomMap(byFactor: 0.5)
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        if isSearching {
            toggleTable()
        }
        
        var areaCode = ""
        if let zip = addy.areaCode {
            areaCode = String(zip)
        }
        searchField.text = "\(addy.digits) \(addy.street), \(addy.city), \(addy.state) \(areaCode)"
        searchField.resignFirstResponder()
        selectBtn.isEnabled = true
    }
    
}
