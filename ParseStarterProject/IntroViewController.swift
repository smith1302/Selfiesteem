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

class IntroViewController: LoginViewController {
    
    override func getLogoImage() -> UIImage? {
        return UIImage(named: "logo100.fw.png")
    }
    
    /*
    * User is signed up or logged in. Lets take them to the main app
    */
    override func continueToMainApp() {
        activityIndicator.startAnimating()
        let storyboard = Constants.storyboard
        let mainAppVC = storyboard.instantiateViewControllerWithIdentifier("MainNavigationViewController")
        self.presentViewController(mainAppVC, animated: true, completion: {
            self.activityIndicator.stopAnimating()
        })
        // Set them up with push when they login
        PFPush.subscribeToChannelInBackground(User.currentUser()!.objectId!) { (succeeded: Bool, error: NSError?) in
            if succeeded {
                print("Subscribed to user channel.\n");
            } else {
                print("Couldnt subscribe to user channel with error = %@.\n", error)
            }
        }
    }

}
