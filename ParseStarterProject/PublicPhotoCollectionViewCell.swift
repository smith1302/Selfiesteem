//
//  PublicPhotoCollectionViewCell.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PublicPhotoCollectionViewCell: PFCollectionViewCell {

    @IBOutlet weak var pfImageView: CachedPFImageView!
    
    func configure(file:PFFile) {
        pfImageView.file = file;
        // Need to figure out a fix for this. Configure is called before the cell's frame is made. So the imageview frame is wrong thus we cant
        // set the corner radius properly. Waiting until the load is done works, but the load isnt always triggered if the image is cached.
        // Need to figure out when to call this method after everything is setup.
        pfImageView.loadInBackground({
            (image, error) in
            self.pfImageView.layer.cornerRadius = (self.pfImageView.frame.size.height)/2
        })
        pfImageView.layer.masksToBounds = true
        pfImageView.layer.borderColor = UIColor(red: 0.834, green: 0.978, blue: 1.000, alpha: 0.4).CGColor
        pfImageView.layer.borderWidth = 5
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
