//
//  RatePhotoViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RatePhotoViewController: UIViewController {
    
    var fileToLoad:PFFile!
    @IBOutlet weak var imageView: CachedPFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Either loads it or uses the cached version
        imageView.file = fileToLoad
        imageView.loadInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpWithFile(file:PFFile!) {
        self.fileToLoad = file
    }
    
    @IBAction func didTapImageView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
