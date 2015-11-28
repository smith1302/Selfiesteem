//
//  CustomPickerView.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/27/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class CustomPickerView: UIPickerView {
    
    var coverView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        coverView = UIView(frame: CGRectMake(0, self.frame.size.height/2 - (NumberPickerCell.cellHeight+2)/2, self.frame.size.width, NumberPickerCell.cellHeight+2))
        coverView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        addSubview(coverView)
    }

}
