//
//  OverlayButton.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class OverlayButton: UIButton {
    
    let defaultColor = UIColor(white: 0.4, alpha: 0.4)
    let selectedColor = UIColor(white: 0.1, alpha: 0.8)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.height*0.2
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/6
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 3
        self.backgroundColor = UIColor.clearColor()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func pressed() {
        //self.backgroundColor = selectedColor
        self.transform = CGAffineTransformMakeScale(1.07, 1.07)
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
