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
    
    // Need this functionality to update the frame as soon as the bound is set to the imageView can calculate the corner radius before rendering
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    func configure(file:PFFile) {
        pfImageView.file = file;
        pfImageView.loadInBackground()
        pfImageView.layoutIfNeeded()
        self.pfImageView.layer.cornerRadius = (self.pfImageView.frame.size.height)/2
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
