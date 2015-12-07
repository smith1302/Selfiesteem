//
//  PhotoRatingCell.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/21/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoRatingCell: PFTableViewCell {

    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    var rating:Rating?
    
    func configure(rating:Rating) {
        self.selectionStyle = .None
        self.rating = rating
        RatingLabel.text = String(rating.rating)
        RatingLabel.layer.cornerRadius = RatingLabel.frame.size.width/2
        RatingLabel.layer.borderColor = UIColor(white: 0.6, alpha: 1).CGColor
        RatingLabel.layer.borderWidth = 5
        let comment = (rating.comment.isEmpty) ? "-" : rating.comment
        CommentLabel.text = comment
        if let createdAt = rating.createdAt {
            let readableDate = NSDateFormatter.localizedStringFromDate(createdAt, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
            DateLabel.text = readableDate
        }
        self.backgroundColor = UIColor(white: 1, alpha: 0)
        
        let percentage = rating.rating == 10 ? 0.000001 : (1 - (CGFloat(rating.rating)/10.0))
        let circleWidth:CGFloat = 5
        let circleView = CircleView(center:RatingLabel.center, radius:RatingLabel.frame.size.width/2-circleWidth/2, percent: percentage, color: Constants.primaryColor, width: circleWidth)
        self.addSubview(circleView)
        
        if !rating.seen {
            User.currentUser()!.readRating(rating)
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
