//
//  LeftOverlayButton.swift
//  Selfiesteem
//
//  Created by Eric Smith on 12/1/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class LeftOverlayButton: OverlayButton {
    
    let label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        label.frame = self.bounds
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(self.frame.size.height*0.75)
        label.textAlignment = .Center
        addSubview(label)
    }
    
    override func resetAppearance() {
        super.resetAppearance()
        label.text = ""
    }
    
    func update() {
        User.currentUser()!.unreadRatings({
            (count:Int) in
            if count > 0 {
                self.layer.borderColor = Constants.primaryColor.CGColor
                self.backgroundColor = Constants.primaryColor
                self.label.text = String(count)
            } else {
                self.resetAppearance()
            }
        })
    }
}