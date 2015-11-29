//
//  ActivityIndictator.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/27/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class ActivityIndictator: UIView {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    init() {
        let frame = UIScreen.mainScreen().bounds
        let size:CGFloat = frame.size.width/4
        super.init(frame: CGRectMake(0, 0, size, size))
        customInit(frame)
    }
    
    override init(frame: CGRect) {
        let size:CGFloat = frame.size.width/4
        super.init(frame: CGRectMake(0, 0, size, size))
        customInit(frame)
    }
    
    func customInit(frame:CGRect) {
        let size:CGFloat = frame.size.width/4
        self.center = CGPointMake(frame.width/2, frame.size.height/2)
        self.layer.cornerRadius = size/5
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        activityIndicator.frame = self.bounds
        self.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        stopAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        self.hidden = true
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
        self.hidden = false
    }
    
    func isAnimating() -> Bool {
        return activityIndicator.isAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
