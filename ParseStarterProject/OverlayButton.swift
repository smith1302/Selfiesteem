//
//  OverlayButton.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class OverlayButton: ClickableButton {
    
    let defaultColor = UIColor(white: 0.4, alpha: 0.4)
    let selectedColor = UIColor(white: 0.1, alpha: 0.8)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        resetAppearance()
    }
    
    func resetAppearance() {
        self.layer.cornerRadius = self.frame.size.height*0.2
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height/6
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 3
        self.backgroundColor = UIColor.clearColor()
    }

}
