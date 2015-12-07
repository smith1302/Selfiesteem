//
//  HeaderView.swift
//  Selfiesteem
//
//  Created by Eric Smith on 12/6/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    func configure(text:String) {
        label.text = text
        label.sizeToFit()
        let width = label.frame.size.width
        widthConstraint.constant = width+30
        label.updateConstraints()
    }
        
}
