//
//  Helper.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/28/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    class func setUpNavBar(navigationController: UINavigationController?) {
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = Constants.primaryColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.topItem?.title = Constants.appName
    }
    
    class func makeNavTitleView() -> UIImageView {
        let imageSize:CGFloat = 32
        let image = UIImage(named: "moose-small.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.frame = CGRectMake(0, 0, imageSize, imageSize)
        return imageView
    }
}