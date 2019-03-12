//
//  CMImageVC.swift
//  stat
//
//  Created by Kevin Hall on 3/30/18.
//  Copyright © 2018 Benjamin Neal. All rights reserved.
//

import UIKit

class CMImageVC: UIViewController {
    
//    let transition = CircularAnimation()
    
    /*
     Dismisses VC on Click, located in top right to mimic CameraVC
     */
    let dismissVCButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissVC), for: .touchUpInside)
        return button
    }()
    
    // Best practice to use scroll view to hold image for zooming
//    let imageScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.minimumZoomScale = 1
//        scrollView.maximumZoomScale = 6
//        scrollView.bouncesZoom = true
//        scrollView.isScrollEnabled = true
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        return scrollView
//    }()
    
    /*
     Shows image, will adjust corner radius based on type of image
     */
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        transitioningDelegate = self
        setupUI()
        setupGestureRecognizers()
    }

}

// UI Initialization
extension CMImageVC {
    private func setupUI() {
        view.backgroundColor = .black
        
        //        imageScrollView.delegate = self
        //        // Best Practice to use scroll view to show images for zooming
        //        view.addSubview(imageScrollView)
        //        imageScrollView.anchor(top: view.safeTopAnchor(), left: view.safeLeftAnchor(), bottom: view.safeBottomAnchor(), right: view.safeRightAnchor(), paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //        imageScrollView.addSubview(previewImageView)
        //        // Image will fill up screen (while retaining aspect ratio)
        //        previewImageView.anchor(top: imageScrollView.safeTopAnchor(), left: imageScrollView.safeLeftAnchor(), bottom: imageScrollView.safeBottomAnchor(), right: imageScrollView.safeRightAnchor(), paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //        imageScrollView.contentSize = (previewImageView.image?.size)!
        // Image will fill up screen (while retaining aspect ratio
        view.addSubview(previewImageView)
        previewImageView.anchor(top: view.safeTopAnchor(), left: view.safeLeftAnchor(), bottom: view.safeBottomAnchor(), right: view.safeRightAnchor(), paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        // Dismissal Button in Top Right
        view.addSubview(dismissVCButton)
        dismissVCButton.anchor(top: view.safeTopAnchor(), left: nil, bottom: nil, right: view.safeRightAnchor(), paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    private func setupGestureRecognizers() {
        let swipeDownGestureRec = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissVC))
        swipeDownGestureRec.direction = .down
        view.addGestureRecognizer(swipeDownGestureRec)
    }
    
    // Used so that user can see header information over black background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// UI Routines
extension CMImageVC {
    // Dismisses VC, versatile function
    @objc func handleDismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
}
