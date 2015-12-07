//
//  ActivityIndictator.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/27/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

enum ActivityIndicatorType {
    case Full
    case Box
}

class ActivityIndictator: UIView {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,30,30))

    init(type:ActivityIndicatorType, color:UIColor, frame:CGRect) {
        var loadingFrame:CGRect = frame
        if type == .Box {
            var size:CGFloat = frame.size.width/5
            size = max(40, size)
            loadingFrame = CGRectMake(0, 0, size, size)
        }
        super.init(frame: loadingFrame)
        customInit(frame, color: color)
    }
    
    convenience init() {
        self.init(type:ActivityIndicatorType.Box, color:UIColor(white: 0, alpha: 0.5), frame:UIScreen.mainScreen().bounds)
    }
    
    convenience override init(frame: CGRect) {
        self.init(type:ActivityIndicatorType.Box, color:UIColor(white: 0, alpha: 0.5), frame:frame)
    }
    
    func customInit(frame:CGRect, color:UIColor) {
        self.center = CGPointMake(frame.width/2, frame.size.height/2)
        self.layer.cornerRadius = self.frame.size.width/2
        self.backgroundColor = color
        
//        let image = UIImage(named: "logo100.fw.png")
//        let imageView = UIImageView(image: image)
//        imageView.frame = self.bounds
//        imageView.backgroundColor = Constants.primaryColor
//        imageView.layer.cornerRadius = self.frame.size.width/2
//        imageView.layer.borderColor = UIColor(netHex: 0x99FFC0).CGColor
//        imageView.layer.borderWidth = 5
//        self.addSubview(imageView)
        
        activityIndicator.frame = self.bounds
        self.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        stopAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        UIView.animateWithDuration(0.2, animations: {
            self.hidden = true
        })
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        UIView.animateWithDuration(0.2, animations: {
            self.hidden = false
        })
    }
    
    func remove(callback:(Void) -> Void) {
        UIView.animateWithDuration(0.2, animations: {
                self.alpha = 0
            }, completion: {
                (done:Bool) in
                self.removeFromSuperview()
                callback()
        })
    }
    
    func isAnimating() -> Bool {
        return activityIndicator.isAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
