//
//  NumberPickerCell.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/27/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class NumberPickerCell: UIView {

    var label:UILabel = UILabel()
    static let cellHeight:CGFloat = 45
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        label.font = UIFont.boldSystemFontOfSize(self.frame.size.height*0.8)
        label.textColor = UIColor(white: 0.2, alpha: 1)
        label.textAlignment = .Center
        label.frame = self.bounds
        self.addSubview(label)
    }

}
