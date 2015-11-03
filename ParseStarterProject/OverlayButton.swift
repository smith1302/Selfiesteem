//
//  OverlayButton.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class OverlayButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.height*0.2
        self.clipsToBounds = true
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
