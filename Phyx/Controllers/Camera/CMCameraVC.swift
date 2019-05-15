//
//  CMCameraVC.swift
//  Phyx
//
//  Created by Benjamin Neal on 2/6/18.
//  Copyright © 2018 Benjamin Neal. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol CameraControllerDelegate {
    var selectedImage: UIImage? { get set }
    // var imageName: String? { get set }
}

class CMCameraVC: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var output: AVCapturePhotoOutput?
    var images: [UIImage] = []
    
    var captureDevice: AVCaptureDevice?
    var captureMode = 0
    var flashMode = AVCaptureDevice.FlashMode.off
    
    var cameraDelegate: CameraControllerDelegate?
    
    let imagePicker = UIImagePickerController()
    var mostRecentPhoto: UIImage?
    
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    let changeCameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-camera-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleChangeCamera), for: .touchUpInside)
        return button
    }()
    
    let changeFlashButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-flash-off-50").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleChangeFlash), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = flashMode
        
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        
        guard let unwrappedOutput = output else {
            return
        }
        
        unwrappedOutput.capturePhoto(with: settings, delegate: self)
    }
    
    let mostRecentPhotoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transitioningDelegate = self
        setupDoubleTapGestureRecognizer()
        setupCaptureSession()
        setupHUD()
        fetchPhotos()
        setupImagePicker()
    }
    
    func fetchPhotos () {
        mostRecentPhoto = UIImage()
        fetchMostRecentPhoto()
    }
    
    func fetchMostRecentPhoto() {
        DispatchQueue.main.async {
            let imgManager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
            if fetchResult.count > 0 {
                imgManager.requestImage(for: fetchResult.object(at: 0) as PHAsset, targetSize: CGSize(width: 50, height: 50), contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                    self.mostRecentPhoto = image
                    self.mostRecentPhotoImageView.image = self.mostRecentPhoto
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let delegate = cameraDelegate {
            if let _ = delegate.selectedImage {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        
        let previewImage = UIImage(data: imageData!)
        
        let previewVC = CMPreviewMediaVC()
        previewVC.previewImageView.image = previewImage
        cameraDelegate = previewVC
        present(previewVC, animated: false, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        mostRecentPhoto = image
        self.dismiss(animated: true, completion: nil)
        
        let previewVC = CMPreviewMediaVC()
        previewVC.previewImageView.image = mostRecentPhoto
        cameraDelegate = previewVC
        present(previewVC, animated: true, completion: nil)
    }
    
}

// UI Initialization
extension CMCameraVC {
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1. setup inputs
        if (captureMode == 0){
            captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
        } else {
            captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input:", err)
        }
        
        //2. setup outputs
        output = AVCapturePhotoOutput()
        guard let unwrappedOutput = output else {
            return
        }
        if captureSession.canAddOutput(unwrappedOutput) {
            captureSession.addOutput(unwrappedOutput)
        }
        
        //3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    fileprivate func setupHUD() {
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.safeTopAnchor(), left: nil, bottom: nil, right: view.safeRightAnchor(), paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.safeBottomAnchor(), right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(changeCameraButton)
        changeCameraButton.anchor(top: view.safeTopAnchor(), left: view.safeLeftAnchor(), bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        view.addSubview(changeFlashButton)
        changeFlashButton.anchor(top: changeCameraButton.safeBottomAnchor(), left: view.safeLeftAnchor(), bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        view.addSubview(mostRecentPhotoImageView)
        mostRecentPhotoImageView.anchor(top: nil, left: view.safeLeftAnchor(), bottom: view.safeBottomAnchor(), right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapMostRecentPhotoImageView))
        mostRecentPhotoImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    private func setupDoubleTapGestureRecognizer() {
        let doubleTapGestureRecognizer = UITapGestureRecognizer()
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.addTarget(self, action: #selector(handleChangeCamera))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

// UI Routines
extension CMCameraVC {
    @objc func handleChangeCamera() {
        if (captureMode == 0) {
            captureMode = 1
        } else if (captureMode == 1) {
            captureMode = 0
        }
        setupCaptureSession()
        setupHUD()
    }
    
    @objc func handleChangeFlash() {
        if flashMode == AVCaptureDevice.FlashMode.off {
            flashMode = AVCaptureDevice.FlashMode.on
            changeFlashButton.setImage(#imageLiteral(resourceName: "icons8-flash-on-50").withRenderingMode(.alwaysOriginal), for: .normal)
        } else if flashMode == AVCaptureDevice.FlashMode.on {
            flashMode = AVCaptureDevice.FlashMode.off
            changeFlashButton.setImage(#imageLiteral(resourceName: "icons8-flash-off-50").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapMostRecentPhotoImageView() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}
