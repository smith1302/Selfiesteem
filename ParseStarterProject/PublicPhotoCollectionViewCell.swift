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
    var ratingLabel:UILabel?
    var photo:Photo?
    var activityIndicator:ActivityIndictator?
    var loading:Bool = false
    var alreadyRated:Bool = false
    // For every setBusy() call we need a setFree() call.
    var busyStates:Int = 0
    
    // Need this functionality to update the frame as soon as the bound is set to the imageView can calculate the corner radius before rendering
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    func configure(photo:Photo) {
        self.backgroundColor = UIColor.whiteColor()
        setBusy()
        resetCell()
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
        pfImageView.layer.borderColor = Constants.primaryColorWithAlpha(0.3).CGColor
        pfImageView.layer.borderWidth = 5
        addRatingLabelIfNeeded()
        
        // Create a new CircleView
        let createdAt = photo.createdAt!
        let createdAtSecondsAgo = createdAt.timeIntervalSinceNow
        let percentage = CGFloat(createdAtSecondsAgo/(-60*60*24))
        
        let circleWidth:CGFloat = 4
        let circleView = CircleView(center:pfImageView.center, radius:pfImageView.frame.size.width/2+circleWidth, percent: percentage, color: Constants.primaryColorWithAlpha(0.7), width: circleWidth)
        self.addSubview(circleView)
    }
    
    func resetCell() {
        self.ratingLabel?.removeFromSuperview()
        loading = false
        alreadyRated = false
    }
    
    func addRatingLabelIfNeeded() {
        if alreadyRated {
            return
        }
        setBusy()
        let currentUser:User = User.currentUser()!
        currentUser.getRatingForPhoto(photo, callback: {
            (optionalRating:Rating?) in
            if let rating = optionalRating {
                self.alreadyRated = true
                self.ratingLabel = UILabel(frame: self.pfImageView.bounds)
                self.ratingLabel!.textColor = UIColor.whiteColor()
                self.ratingLabel!.textAlignment = .Center
                self.ratingLabel!.backgroundColor = UIColor(white: 0, alpha: 0.4)
                self.ratingLabel!.font = UIFont.boldSystemFontOfSize(self.ratingLabel!.frame.size.height*0.35)
                self.ratingLabel!.text = String(rating.rating)
                self.pfImageView.addSubview(self.ratingLabel!)
            }
            self.setFree()
        })
    }
    
    func setBusy() {
        busyStates++
        if busyStates > 1 {
            return
        }
        activityIndicator = ActivityIndictator(frame: self.contentView.bounds)
        activityIndicator!.startAnimating()
        self.contentView.addSubview(activityIndicator!)
    }
    
    func setFree() {
        busyStates--
        if busyStates > 0 {
            return
        }
        activityIndicator!.stopAnimating()
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
