//
//  SegueFromRight.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/28/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import QuartzCore

class SeguePopFromRight: UIStoryboardSegue {
    
    override func perform() {
        let src: UIViewController = self.sourceViewController
        let dst: UIViewController = self.destinationViewController
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        src.navigationController!.view.layer.addAnimation(transition, forKey: kCATransition)
        src.navigationController!.popViewControllerAnimated(false)
    }
    
}