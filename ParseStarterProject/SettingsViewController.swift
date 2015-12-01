//
//  SettingsViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var activityIndictator:ActivityIndictator?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndictator = ActivityIndictator()
        activityIndictator!.stopAnimating()
        self.view.addSubview(activityIndictator!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogoutClicked(sender: AnyObject) {
        activityIndictator!.startAnimating()
        User.logOut()
        goToLogin()
    }
    
    func goToLogin() {
        let storyboard = Constants.storyboard
        let mainAppVC = storyboard.instantiateViewControllerWithIdentifier("IntroViewController")
        self.presentViewController(mainAppVC, animated: true, completion: nil)
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
