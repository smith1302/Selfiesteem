//
//  UIRatingTextField.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/11/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class UIRatingTextField: UITextField, UITextFieldDelegate {

    var leftTextMargin : CGFloat = 5.0
    
    init(textSize:CGFloat, leftTextMargin:CGFloat) {
        self.leftTextMargin = leftTextMargin
        super.init(frame: CGRectZero)
        backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        textColor = UIColor(white: 0.9, alpha: 1.000)
        font = UIFont.systemFontOfSize(textSize)
        //delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += leftTextMargin
        return newBounds
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        let currentString: NSString = textField.text!
//        let newString: NSString =
//        currentString.stringByReplacingCharactersInRange(range, withString: string)
//        let newStringSize = newString.sizeWithAttributes([NSFontAttributeName:textField.font!]).width
//        print(newStringSize)
//        return newStringSize <= (textField.frame.size.width - leftTextMargin*2)
//    }

}