import ParseUI
import Parse
import UIKit
import Foundation

public class ImagePostCell : PFTableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet var postImage: PFImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    var notification:UIView?
    var circleView:CircleView?
    var rlView:UIView?
    var photo:Photo?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: "Cell")
        print("Generic Cell Initialization Done")
    }
    
    func configure(photo:Photo) {
        self.backgroundColor = UIColor.whiteColor()
        // Reset if cell is reused
        notification?.removeFromSuperview()
        // Configure cell
        self.photo = photo
        label.text = photo.updatedAt!.timeAgo
        ratingCountLabel.text = "\(photo.numberOfRatings) \(photo.numberOfRatings == 1 ? "Rating" : "Ratings")"
        //Circular image
        postImage.layer.cornerRadius = (self.postImage.frame.size.height)/2
        postImage.layer.masksToBounds = true
        postImage.image = UIImage(named: "ActivityIndicator.gif")
        postImage.file = photo.photoFile
        postImage.loadInBackground()
        postImage.contentMode = .ScaleAspectFill
        postImage.backgroundColor = UIColor.grayColor()
        postImage.layer.borderColor = Constants.primaryColorWithAlpha(0.3).CGColor
        postImage.layer.borderWidth = 5
        
        // Create a new CircleView
        let createdAt = photo.createdAt!
        let createdAtSecondsAgo = createdAt.timeIntervalSinceNow
        let percentage = CGFloat(createdAtSecondsAgo/(-60*60*24)) 
        if percentage <= 1 {
            let circleWidth:CGFloat = 4
            circleView?.removeFromSuperview()
            circleView = CircleView(center:postImage.center, radius:postImage.frame.size.width/2+circleWidth, percent: percentage, color: Constants.primaryColorWithAlpha(0.7), width: circleWidth)
            self.addSubview(circleView!)
        }
        
        rLabel.layer.cornerRadius = rLabel.frame.size.height/2
        rLabel.layer.borderColor = Constants.primaryColorWithAlpha(0.5).CGColor //UIColor(white: 0.9, alpha: 1).CGColor
        rLabel.layer.borderWidth = 6
        rLabel.text = String(photo.averageRating)
        
        photo.hasUnreadRatings({
            (hasUnread:Bool) in
            if hasUnread {
                // Set up seen notifier
                let notifierSize:CGFloat = 17
                let x = self.postImage.frame.origin.x + self.postImage.frame.size.width - notifierSize/2
                let y = self.postImage.frame.origin.y + self.postImage.frame.size.width/2 - notifierSize/2
                self.notification = UIView(frame: CGRectMake(x, y, notifierSize, notifierSize))
                self.notification!.backgroundColor = UIColor.orangeColor()
                self.notification!.layer.cornerRadius = notifierSize/2
                self.notification!.layer.borderWidth = 3
                self.notification!.layer.borderColor = UIColor.whiteColor().CGColor
                self.addSubview(self.notification!)
            } else {
                self.notification?.removeFromSuperview()
            }
        })
    }
    
    func getDateString(date:NSDate) -> String {
        let diff = date.calenderComponentDifference(date)
        var returnString = "a while ago."
        if (diff.year > 0) {
            returnString = "\(diff.year) years ago."
        } else if (diff.month > 0) {
            returnString = "\(diff.month) months ago."
        } else if (diff.weekOfYear > 0) {
            returnString = "\(diff.weekOfYear) weeks ago."
        } else if (diff.day > 0) {
            if (diff.day > 1) {
                returnString = "\(diff.day) days ago."
            } else {
                returnString = "yesterday."
            }
        } else {
            returnString = "today.";
        }
        return returnString
    }
    
    func updateSeenState() {
        if photo == nil {
            return
        }
        photo!.hasUnreadRatings({
            (hasUnread:Bool) in
            if !hasUnread {
                self.notification?.removeFromSuperview()
            }
        })
    }
    
    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        rlView?.backgroundColor = UIColor.whiteColor()
    }
    
    public override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        rlView?.backgroundColor = UIColor.whiteColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }
}
