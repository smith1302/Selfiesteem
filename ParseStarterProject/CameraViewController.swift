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
        // Immediately show the camera
        self.presentCamera()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.delegate = self // That way the delegate methods below get called so we know whats going on
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            // TODO: ErrorHandler.showMessage("Device does not have a camera")
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
        let photoFile = PFFile(data: imageData!)
        photoFile?.saveInBackground()
        // TODO: 
        //      1) Have photoFile save in background thread incase user closes the app before upload is finished
        //      2) Have error handling if upload fails
        //      3) Attach file to PFObject and associated with user
        //      4) Upload PFObject to Parse
        
        // Return false as default until I finish the above TODO list
        return false
    }


}
