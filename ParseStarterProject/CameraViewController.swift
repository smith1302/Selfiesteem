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

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraControlsView: UIView!
    @IBOutlet weak var bottomRightButton: OverlayButton!
    @IBOutlet weak var bottomLeftButton: LeftOverlayButton!
    @IBOutlet weak var topRightButton: ClickableButton!
    @IBOutlet weak var cameraButton: CameraButton!
    @IBOutlet weak var cameraPreview: UIView!
    
    let imagePicker = UIImagePickerController()
    let sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
    let stillImageOutput = AVCaptureStillImageOutput()
    let captureMetadataOutput = AVCaptureMetadataOutput()
    var outputConnection : AVCaptureConnection?
    let activityIndicator:ActivityIndictator = ActivityIndictator()
    var currentImage:UIImage?
    let controlTransitionTime:NSTimeInterval = 0.5
    var previewLayer:AVCaptureVideoPreviewLayer!
    var faceDetector:FaceDetectionView?
    
    // Constraints
    @IBOutlet weak var CameraControlsBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var PostImageControlsBottomConstraint: NSLayoutConstraint!
    
    // Post Image Controls
    @IBOutlet weak var cancelButton: ClickableButton!
    @IBOutlet weak var submitButton: ClickableButton!
    @IBOutlet weak var postImageControlsView: UIView!
    
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
        
        // Face detection
        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            for type in captureMetadataOutput.availableMetadataObjectTypes {
                if let assertedType = type as? String where assertedType == AVMetadataObjectTypeFace {
                    captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
                }
            }
        }
        
        // Initialize FRAME to highlight face
        faceDetector = FaceDetectionView()
        view.addSubview(faceDetector!)
        view.bringSubviewToFront(faceDetector!)

        
        // Configure post image controls
        let attributedText = NSMutableAttributedString(string: "X", attributes: [
                        NSFontAttributeName : cancelButton.titleLabel!.font,
                        NSForegroundColorAttributeName: UIColor.whiteColor(),
                        NSStrokeColorAttributeName: UIColor(white: 0.2, alpha: 1),
                        NSStrokeWidthAttributeName: -2
                        ])
        cancelButton.titleLabel?.textAlignment = .Left
        cancelButton.titleLabel?.attributedText = attributedText
        
        // Upload button
        let uploadImage = UIImage(named: "Upload.png")
        topRightButton.setImage(uploadImage, forState: UIControlState.Normal)
        topRightButton.tintColor = UIColor.whiteColor()
        topRightButton.backgroundColor = UIColor.clearColor()
        topRightButton.alpha = 0.8
        
        // Show controls
        showCameraControls()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden=true;
        bottomLeftButton.update()
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rootViewSetup() {
        Helper.setUpNavBar(self.navigationController)
    }
    
    // ------- Mark: ImagePickerControllerDelegate
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.delegate = self // That way the delegate methods below get called so we know whats going on
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            ErrorHandler.showAlert("Device does not have a camera")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.shouldUploadImage(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ------- Mark: AVFoundation camera stuff
    
    func beginCameraSession() {
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print(error)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
        cameraPreview.layer.addSublayer(previewLayer)
        previewLayer.frame = self.view.layer.frame
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
                    device.focusMode = .AutoFocus
                }
                if device.isExposureModeSupported(AVCaptureExposureMode.AutoExpose) {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = .AutoExpose
                }
                device.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touchPoint = touches.first {
            let screenSize = cameraPreview.bounds.size
            let focusPoint = CGPoint(x: touchPoint.locationInView(cameraPreview).y / screenSize.height, y: touchPoint.locationInView(cameraPreview).x / screenSize.width)
            focusTo(focusPoint)
        }
    }
    
    // ------- Mark: Uploading
    
    func shouldUploadImage(image:UIImage) -> Bool {
        
        if User.currentUser()!.selfiesToday >= 5 {
            let lastSelfie = User.currentUser()!.mostRecentSelfie
            let yesterday = NSDate().addDays(-1)
            // We posted 5 today
            if !lastSelfie.isLessThanDate(yesterday) {
                MessageHandler.easyAlert("Sorry", message: "You can only post 5 selfies in 24 hours")
                showCameraControls()
                return false
            } else {
                User.currentUser()!.selfiesToday = 0
            }
        }
        
        activityIndicator.startAnimating()
        hidePostImageControls()
        hideCameraControls()
        
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
            photo.mostRecentRating = NSDate()
            let photoACL = PFACL(user: User.currentUser()!)
            photoACL.setPublicReadAccess(true)
            photoACL.setPublicWriteAccess(true)
            photo.ACL = photoACL
            
            User.currentUser()!.selfiesToday++
            User.currentUser()!.mostRecentSelfie = NSDate()
            User.currentUser()!.saveEventually()
            
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
        faceDetector?.hide()
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
    
    // ---- Mark: Face detection
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            faceDetector?.hide()
            return
        }
        
        for metadataObject in metadataObjects as! [AVMetadataObject] {
            if metadataObject.type == AVMetadataObjectTypeFace {
                let transformedMetadataObject = previewLayer.transformedMetadataObjectForMetadataObject(metadataObject)
                faceDetector?.showAtFrame(transformedMetadataObject.bounds)
            }
        }
    }
    
    // ---- Mark: IBAction
    
    @IBAction func UploadBtnClicked(sender: AnyObject) {
        self.presentCamera()
    }
    

    @IBAction func cameraBtnClicked(sender: AnyObject) {
        if activityIndicator.isAnimating() {
            return
        }
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
