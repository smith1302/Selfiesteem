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

    @IBOutlet weak var pfImageView: PFImageView!
    
    func configure(file:PFFile) {
        pfImageView.file = file;
        pfImageView.loadInBackground()
        pfImageView.layer.cornerRadius = pfImageView.frame.size.height/3
        pfImageView.layer.masksToBounds = true
        pfImageView.layer.borderColor = UIColor(red: 0.706, green: 0.962, blue: 1.000, alpha: 1.000).CGColor
        pfImageView.layer.borderWidth = 3
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
