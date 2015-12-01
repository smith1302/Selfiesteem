//
//  CameraViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

let kPhotoUploadSuccess = "Your selfie has been sent!"

class CameraViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var cameraControlsView: UIView!
    @IBOutlet weak var bottomRightButton: OverlayButton!
    @IBOutlet weak var bottomLeftButton: OverlayButton!
    @IBOutlet weak var cameraButton: CameraButton!
    @IBOutlet weak var cameraPreview: UIView!
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    let stillImageOutput = AVCaptureStillImageOutput()
    var outputConnection : AVCaptureConnection?
    let activityIndicator:ActivityIndictator = ActivityIndictator()
    let sourceType = UIImagePickerControllerSourceType.Camera
    var currentImage:UIImage?
    let controlTransitionTime:NSTimeInterval = 0.5
    
    // Constraints
    @IBOutlet weak var CameraControlsBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var PostImageControlsBottomConstraint: NSLayoutConstraint!
    
    // Post Image Controls
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var postImageControlsView: UIView!
    
    @IBOutlet weak var overlayButton: OverlayButton!
    
    // Image upload background thread IDs
    var fileUploadBackgroundTaskID:UIBackgroundTaskIdentifier?
    var photoPostBackgroundTaskID:UIBackgroundTaskIdentifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Since this is the root view, set up some stuff
        rootViewSetup()
        // Do any additional setup after loading the view.
        self.view.frame.offsetInPlace(dx: 0, dy: 20)
        self.view.addSubview(activityIndicator)
        // Input
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        // Loop through all the capture devices on this phone (front, back, etc)
        for device in devices {
            if(device.position == AVCaptureDevicePosition.Front) {
                captureDevice = device as? AVCaptureDevice
                if captureDevice != nil {
                    self.beginCameraSession()
                }
            }
        }
        
        // Output
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        if let outputConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            self.outputConnection = outputConnection
            // update the video orientation to the device one
            let videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.currentDevice().orientation.rawValue)
            outputConnection.videoOrientation = videoOrientation!
        }
        
        // Configure post image controls
        let attributedText = NSMutableAttributedString(string: "X", attributes: [
                        NSFontAttributeName : cancelButton.titleLabel!.font,
                        NSForegroundColorAttributeName: UIColor.whiteColor(),
                        NSStrokeColorAttributeName: UIColor(white: 0.2, alpha: 1),
                        NSStrokeWidthAttributeName: -2
                        ])
        cancelButton.titleLabel?.textAlignment = .Left
        cancelButton.titleLabel?.attributedText = attributedText
        
        let image = UIImage(named: "Next-64.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        submitButton.setImage(image, forState: UIControlState.Normal)
        submitButton.tintColor = UIColor.whiteColor()
        
        // Show controls
        showCameraControls()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden=true;
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Immediately show the camera
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rootViewSetup() {
        Helper.setUpNavBar(self.navigationController)
    }
    
    func beginCameraSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print(error)
        }
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        cameraPreview.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch {
                print(error)
            }
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
    }
    
    func focusTo(focusPoint:CGPoint) {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
                if device.focusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = .ContinuousAutoFocus
                }
                if device.exposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = .ContinuousAutoExposure
                }
            } catch {
                print(error)
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let anyTouch = touches.first {
            let touchPoint = anyTouch.locationInView(self.view)
            focusTo(touchPoint)
        }
    }
    
    // ------- Mark: Uploading
    
    func shouldUploadImage(image:UIImage) -> Bool {
        
        hidePostImageControls()
        
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        if imageData == nil {
            self.uploadFinished()
            return false
        }
        if let photoFile = PFFile(data: imageData!) {
            // Create a background thread to continue the operation if the user backgrounds the app
            fileUploadBackgroundTaskID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                UIApplication.sharedApplication().endBackgroundTask(self.fileUploadBackgroundTaskID!)
            })
            // Save the photo
            photoFile.saveInBackgroundWithBlock {
                (success:Bool, error:NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.fileUploadBackgroundTaskID!)
                if error != nil {
                    ErrorHandler.showAlert(error?.description)
                }
            }
            // Attach the photo to a PFObject
            let photo = Photo(className: "Photos", dictionary: nil)
            photo.photoFile = photoFile
            photo.userID = PFUser.currentUser()!.objectId!
            photo.seen = true
            photo.mostRecentRating = NSDate()
            let photoACL = PFACL(user: User.currentUser()!)
            photoACL.setPublicReadAccess(true)
            photoACL.setWriteAccess(true, forUser: User.currentUser()!)
            photo.ACL = photoACL
            
            // Make another background thread for uploading the PFObject
            photoPostBackgroundTaskID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                UIApplication.sharedApplication().endBackgroundTask(self.photoPostBackgroundTaskID!)
            })
            
            // Upload the PFObject
            photo.saveInBackgroundWithBlock({
                (success:Bool, error:NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoPostBackgroundTaskID!)
                self.uploadFinished()
                if error != nil {
                    ErrorHandler.showAlert(error?.description)
                } else if success {
                    MessageHandler.showMessage(kPhotoUploadSuccess)
                }
            })
        }
        
        return false
    }
    
    func showCameraControls() {
        currentImage = nil
        cameraControlsView.hidden = false
        hidePostImageControls()
        if !captureSession.running {
            captureSession.startRunning()
        }
        self.CameraControlsBottomContraint.constant = 0
        UIView.animateWithDuration(controlTransitionTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hideCameraControls() {
        self.CameraControlsBottomContraint.constant = -self.cameraControlsView.frame.size.height*2
        UIView.animateWithDuration(controlTransitionTime, animations: {
            self.view.layoutIfNeeded()
        }, completion: {
            (done:Bool) in
            self.cameraControlsView.hidden = true
        })
    }
    
    func showPostImageControls() {
        hideCameraControls()
        postImageControlsView.hidden = false
        self.PostImageControlsBottomConstraint.constant = 0
        UIView.animateWithDuration(controlTransitionTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func hidePostImageControls() {
        self.PostImageControlsBottomConstraint.constant = -self.postImageControlsView.frame.size.height*2
        UIView.animateWithDuration(controlTransitionTime, animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (done:Bool) in
            self.postImageControlsView.hidden = true
        })
    }
    
    // ---- Mark: IBAction

    @IBAction func cameraBtnClicked(sender: AnyObject) {
        if outputConnection == nil {
            ErrorHandler.showAlert("Something went wrong")
            return
        }
        stillImageOutput.captureStillImageAsynchronouslyFromConnection(outputConnection) {
            (imageDataSampleBuffer, error) -> Void in
            
            if error == nil {
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                if let image = UIImage(data: imageData) {
                    self.captureSession.stopRunning()
                    self.view.layer.contents = image
                    self.currentImage = image
                    self.showPostImageControls()
                }
            }
            else {
                NSLog("error while capturing still image: \(error)")
            }
        }
    }
    
    func uploadFinished() {
        activityIndicator.stopAnimating()
        showCameraControls()
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        showCameraControls()
    }
    
    @IBAction func submitButtonClicked(sender: AnyObject) {
        if activityIndicator.isAnimating() {
            return
        }
        if let currentImage = currentImage {
            shouldUploadImage(currentImage)
            activityIndicator.startAnimating()
        }
    }
   
    @IBAction func swipeRightAction(sender: AnyObject) {
        self.performSegueWithIdentifier("segueToHistoryOfImagesViewController", sender: nil);
    }
    @IBAction func swipeLeftAction(sender: AnyObject) {
        self.performSegueWithIdentifier("segueToPublicPhotosViewController", sender: nil);
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue){
        
    }
}
