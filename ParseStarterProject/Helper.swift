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
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),
                                                                   NSFontAttributeName: UIFont.systemFontOfSize(24)]
        navigationController?.navigationBar.topItem?.title = Constants.appName
    }
    
//    class func makeNavTitleView() -> UIImageView {
//        let imageSize:CGFloat = 32
//        let image = UIImage(named: "logo40.fw.png")
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit
//        imageView.frame = CGRectMake(0, 0, imageSize, imageSize)
//        return imageView
//    }
    
    class func makeNavTitleView() -> UILabel {
        let size:CGFloat = 28
        let label = UILabel()
        label.text = Constants.appName
        label.font = UIFont.systemFontOfSize(size)
        label.textColor = UIColor.whiteColor()
        label.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, size)
        label.textAlignment = .Center
        return label
    }
}