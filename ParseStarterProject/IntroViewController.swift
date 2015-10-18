/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import ParseUI

class IntroViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    // Instantiate our login and sign up views
    var loginViewController: PFLogInViewController = PFLogInViewController()
    var signUpViewController: PFSignUpViewController = PFSignUpViewController()
    
    /*
    * When the view appears, we need to check if the user is already logged in. If they are let's skip this screen
    * and go straight to the main app.
    */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if (PFUser.currentUser() == nil) {
            // Set up our login view controller
            self.loginViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton,  PFLogInFields.SignUpButton]
            let loginLogoTitle = UILabel()
            loginLogoTitle.text = Constants.appName
            self.loginViewController.logInView?.logo = loginLogoTitle
            self.loginViewController.delegate = self
            
            // Set up the sign up view controller
            let signUpLogoTitle = UILabel()
            signUpLogoTitle.text = Constants.appName
            self.signUpViewController.signUpView?.logo = signUpLogoTitle
            self.signUpViewController.delegate = self
            self.loginViewController.signUpController = self.signUpViewController
            // We have no current user, so let's show them the login view
            continueToLogin()
        } else {
            self.continueToMainApp()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ----- Mark: PFLogInViewControllerDelegate
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        if (username.isEmpty || password.isEmpty) {
            return false
        }
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        ErrorHandler.showAlert("Failed to login.");
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        print("Dismissed login")
    }
    
    // ----- Mark: PFSignUpViewControllerDelegate
    
    func signUpViewController(signUpController: PFSignUpViewController, shouldBeginSignUp info: [NSObject : AnyObject]) -> Bool {
        let username = info["username"] as! String
        let password = info["password"] as! String
        let email = info["email"] as! String
        if (username.isEmpty || password.isEmpty || email.isEmpty) {
            ErrorHandler.showAlert("Fields cannot be empty.");
            return false
        }
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        ErrorHandler.showAlert("Failed to signup.");
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("User dismissed sign up")
    }
    
    // ----- Mark: View transitions
    
    func continueToLogin() {
        self.presentViewController(loginViewController, animated: true, completion: nil)
    }
    
    /*
    * User is signed up or logged in. Lets take them to the main app
    */
    func continueToMainApp() {
        let storyboard = Constants.storyboard
        let mainAppVC = storyboard.instantiateViewControllerWithIdentifier("CameraViewController")
        self.presentViewController(mainAppVC, animated: true, completion: nil)
    }
    
    // ----- Mark: Other
    
    @IBAction func logOut(segue: UIStoryboardSegue) {
        PFUser.logOut()
    }
}
