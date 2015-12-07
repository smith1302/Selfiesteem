//
//  PublicPhotoImageView.swift
//  Selfiesteem
//
//  Created by Eric Smith on 12/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit
import ParseUI

class PublicPhotoImageView : PFImageView {
    func pressed() {
        UIView.animateWithDuration(1,
            delay: 0,
            usingSpringWithDamping: 0.15,
            initialSpringVelocity: 2,
            options: .CurveEaseInOut,
            animations: {
                self.transform = CGAffineTransformMakeScale(1.11, 1.11)
            },
            completion: nil)
    }
    
    func released() {
        UIView.animateWithDuration(1,
            delay: 0,
            usingSpringWithDamping: 0.55,
            initialSpringVelocity: 0.8,
            options: .CurveEaseInOut,
            animations: {
                self.transform = CGAffineTransformMakeScale(1, 1)
            },
            completion: nil)
    }
}