//
//  CustomPFQueryTableViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 12/3/15.
//  Copyright © 2015 Parse. All rights reserved.

import UIKit
import Parse
import ParseUI

class CustomPFQueryTableViewController: PFQueryTableViewController {
    var activityIndictator:ActivityIndictator?
    var hasFinishedInitialLoad:Bool = false
    
    override func objectsWillLoad() {
        if activityIndictator != nil {
            return
        }
        super.objectsWillLoad()
        activityIndictator = ActivityIndictator()
        let mainView = UIApplication.sharedApplication().keyWindow
        mainView?.addSubview(self.activityIndictator!)
        activityIndictator?.startAnimating()
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        activityIndictator?.remove({
            self.activityIndictator = nil
        })
        if !hasFinishedInitialLoad {
            if self.objects?.count < 1 {
                loadObjects()
            }
            hasFinishedInitialLoad = true
        }
    }

}
