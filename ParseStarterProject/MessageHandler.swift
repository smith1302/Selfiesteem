//
//  MessageHandler.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/26/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class MessageHandler {
    static var errorWindow: UIWindow?
    static var errorWindowLabel:UILabel!
    static let defaultTime:NSTimeInterval = 4
    static let height:CGFloat = 30
    
    static func showMessage(text:String, withDuration:NSTimeInterval) {
        
        if errorWindow == nil {
            let keyWindow = UIApplication.sharedApplication().keyWindow!
            errorWindow = UIWindow(frame: CGRectMake(0, 0, keyWindow.frame.size.width, height))
            
            let errorView = UIView(frame: CGRectMake(0, 0, keyWindow.frame.size.width, height))
            errorView.backgroundColor = UIColor.redColor()
            
            errorWindowLabel = UILabel(frame: CGRectMake(0, 0, keyWindow.frame.size.width, height))
            errorWindowLabel.text = text
            errorWindowLabel.textColor = UIColor.whiteColor()
            errorWindowLabel.font = UIFont.boldSystemFontOfSize(height*0.6)
            errorWindowLabel.textAlignment = NSTextAlignment.Center
            
            errorView.addSubview(errorWindowLabel)
            errorWindow!.addSubview(errorView)
            errorWindow!.windowLevel = UIWindowLevelStatusBar+1
            errorWindow!.makeKeyAndVisible()
            
            errorWindow!.transform = CGAffineTransformMakeTranslation(0, -1*height)
            
            // Animate into place
            UIView.animateWithDuration(0.2,
                animations: {
                    errorWindow!.transform = CGAffineTransformMakeTranslation(0, 0)
                },
                completion: {
                    finished in
                    // hide message after time is up
                    self.hideMessage(withDuration)
            })
            
        } else {
            errorWindowLabel.text = text
            UIView.animateWithDuration(0.2,
                animations: {
                    errorWindow!.transform = CGAffineTransformMakeTranslation(0, 0)
                },
                completion: {
                    finished in
                    // hide message after time is up
                    self.hideMessage(withDuration)
            })
        }
    }
    
    static func showMessage(text:String) {
        showMessage(text, withDuration: defaultTime)
    }
    
    class func hideMessage(delay:NSTimeInterval) {
        UIView.animateWithDuration(0.2, delay: delay, options: [],
            animations: {
                if errorWindow != nil {
                    errorWindow!.transform = CGAffineTransformMakeTranslation(0, -height)
                }
            }, completion: nil)
    }

}