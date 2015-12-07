//
//  ClickableButton
//  Selfiesteem
//
//  Created by Eric Smith on 11/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class ClickableButton: UIButton {
    
    func pressed() {
        //self.backgroundColor = selectedColor
        self.transform = CGAffineTransformMakeScale(1.15, 1.15)
    }
    
    func released() {
        //self.backgroundColor = defaultColor
        self.transform = CGAffineTransformMakeScale(1, 1)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        pressed()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        released()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        released()
    }
    
}
