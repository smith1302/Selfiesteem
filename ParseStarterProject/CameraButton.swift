//
//  CameraButton.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/26/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class CameraButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    func customInit() {
        self.layer.cornerRadius = self.frame.size.height/2
        let circleView = CircleView(center: CGPointMake(bounds.size.width/2, bounds.size.height/2), radius: self.frame.size.height/2 * 0.9, percent: 0.0001, color: UIColor(white: 0.5, alpha: 1), width:2.0)
        circleView.userInteractionEnabled = false
        self.addSubview(circleView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func pressed() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
        self.transform = CGAffineTransformMakeScale(1.05, 1.05)
    }
    
    func released() {
        self.backgroundColor = UIColor.whiteColor()
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
