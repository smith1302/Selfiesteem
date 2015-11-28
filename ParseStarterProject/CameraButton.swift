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
        let circleView = CircleView(frame: self.bounds, percent: 1, color: UIColor(white: 0.5, alpha: 1))
        circleView.userInteractionEnabled = false
        self.addSubview(circleView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func pressed() {
        self.backgroundColor = UIColor(white: 0.9, alpha: 0.8)
    }
    
    func released() {
        self.backgroundColor = UIColor.whiteColor()
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
