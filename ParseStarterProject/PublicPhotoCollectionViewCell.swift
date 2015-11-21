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
    var photo:Photo?
    var activityIndicator:UIActivityIndicatorView?
    var loading:Bool = false
    var alreadyRated:Bool = false
    
    // Need this functionality to update the frame as soon as the bound is set to the imageView can calculate the corner radius before rendering
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    func configure(photo:Photo) {
        setBusy()
        self.loading = true
        self.alreadyRated = false
        self.photo = photo
        pfImageView.file = photo.photoFile;
        pfImageView.loadInBackground({
            (image, error) in
            self.loading = false
            self.setFree()
        })
        pfImageView.layoutIfNeeded()
        self.pfImageView.layer.cornerRadius = (self.pfImageView.frame.size.height)/2
        pfImageView.layer.masksToBounds = true
        pfImageView.layer.borderColor = UIColor(red: 0.834, green: 0.978, blue: 1.000, alpha: 0.4).CGColor
        pfImageView.layer.borderWidth = 5
        update()
    }
    
    func update() {
        goGhostIfNeeded()
    }
    
    func goGhostIfNeeded() {
        setBusy()
        let currentUser:User = User.currentUser()!
        currentUser.getRatingForPhoto(photo, callback: {
            (optionalRating:Rating?) in
            if let rating = optionalRating {
                self.alreadyRated = true
                let text = UILabel(frame: self.pfImageView.bounds)
                text.textColor = UIColor.whiteColor()
                text.textAlignment = .Center
                text.backgroundColor = UIColor(white: 0, alpha: 0.4)
                text.font = UIFont.boldSystemFontOfSize(text.frame.size.height*0.5)
                text.text = String(rating.rating)
                self.pfImageView.addSubview(text)
            }
            self.setFree()
        })
    }
    
    func setBusy() {
        setFree()
        activityIndicator = UIActivityIndicatorView(frame: self.contentView.frame)
        activityIndicator!.startAnimating()
        self.contentView.addSubview(activityIndicator!)
    }
    
    func setFree() {
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
    
    func isInactive() -> Bool {
        return loading || alreadyRated
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
