//
//  CameraViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 10/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    // Image upload background thread IDs
    var fileUploadBackgroundTaskID:UIBackgroundTaskIdentifier?
    var photoPostBackgroundTaskID:UIBackgroundTaskIdentifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Immediately show the camera
        self.presentCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            imagePicker.delegate = self // That way the delegate methods below get called so we know whats going on
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            ErrorHandler.showAlert("Device does not have a camera")
        }
    }
    

    // ------- Mark: ImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.shouldUploadImage(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ------- Mark: Uploading
    
    func shouldUploadImage(image:UIImage) ->Bool {
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        if imageData == nil {
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
            let photoObject = PFObject(className: "Photos")
            photoObject.setObject(photoFile, forKey: "photoFile")
            photoObject.setObject(PFUser.currentUser()!.objectId!, forKey: "userID")
            let photoACL = PFACL(user: PFUser.currentUser()!)
            photoACL.setPublicReadAccess(true)
            photoObject.ACL = photoACL
            
            // Make another background thread for uploading the PFObject
            photoPostBackgroundTaskID = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({
                UIApplication.sharedApplication().endBackgroundTask(self.photoPostBackgroundTaskID!)
            })
            
            // Upload the PFObject
            photoObject.saveInBackgroundWithBlock({
                (success:Bool, error:NSError?) -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.fileUploadBackgroundTaskID!)
                if error != nil {
                    ErrorHandler.showAlert(error?.description)
                }
                // Cache photo on success
            })
        }
        
        // Return false as default until I finish the above TODO list
        return false
    }


}
