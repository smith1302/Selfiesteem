import ParseUI
import Parse
import UIKit
import Foundation

public class ImagePostCell : PFTableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet var postImage: PFImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var rLabel: UILabel!
    var ratingLabel:UILabel?
    var notification:UIView?
    var rlView:UIView?
    var photo:Photo?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: "Cell")
        print("Generic Cell Initialization Done")
    }
    
    func configure(photo:Photo) {
        self.backgroundColor = UIColor.whiteColor()
        // Reset if cell is reused
        ratingLabel?.removeFromSuperview()
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
            let circleView = CircleView(center:postImage.center, radius:postImage.frame.size.width/2+circleWidth, percent: percentage, color: Constants.primaryColorWithAlpha(0.7), width: circleWidth)
            self.addSubview(circleView)
        }
        
        // Set up rating label
//        let rlViewSize:CGFloat = 35
//        let radius:CGFloat = 1
//        let circleCornerDist = (postImage.frame.size.width/2)*cos(45)*radius
//        let circleCornerDistB = circleCornerDist + (rlViewSize/4)*cos(45)
//        let rlViewX = postImage.frame.origin.x + postImage.frame.size.width/2 + circleCornerDistB - rlViewSize/2
//        let rlViewY = postImage.frame.origin.y + postImage.frame.size.width/2 - circleCornerDistB - rlViewSize/2
//        rlView = UIView(frame: CGRectMake(rlViewX, rlViewY, rlViewSize, rlViewSize))
//        rlView!.backgroundColor = Constants.primaryColorWithAlpha(0.7) //UIColor.whiteColor()
//        rlView!.layer.cornerRadius = rlViewSize/2
//        rlView!.clipsToBounds = true
//        rlView!.layer.borderWidth = 5
//        rlView!.layer.borderColor = Constants.primaryColorWithAlpha(0.7).CGColor
//        ratingLabel = UILabel(frame: rlView!.bounds)
//        ratingLabel!.text = String(photo.averageRating)
//        ratingLabel!.textColor = UIColor.whiteColor()//UIColor(white: 0.3, alpha: 1)
//        ratingLabel!.backgroundColor = rlView!.backgroundColor
//        ratingLabel!.textAlignment = .Center
//        ratingLabel!.font = UIFont.boldSystemFontOfSize(rlView!.frame.size.height*0.5)
//        rlView?.addSubview(ratingLabel!)
        //self.addSubview(rlView!)
        
        rLabel.layer.cornerRadius = rLabel.frame.size.height/2
        rLabel.layer.borderColor = Constants.primaryColorWithAlpha(0.5).CGColor //UIColor(white: 0.9, alpha: 1).CGColor
        rLabel.layer.borderWidth = 6
        rLabel.text = String(photo.averageRating)
        
        if !photo.seen {
            // Set up seen notifier
            let notifierSize:CGFloat = 17
            let x = postImage.frame.origin.x + postImage.frame.size.width - notifierSize/2
            let y = postImage.frame.origin.y + postImage.frame.size.width/2 - notifierSize/2
            notification = UIView(frame: CGRectMake(x, y, notifierSize, notifierSize))
            notification!.backgroundColor = UIColor.orangeColor()
            notification!.layer.cornerRadius = notifierSize/2
            notification!.layer.borderWidth = 3
            notification!.layer.borderColor = UIColor.whiteColor().CGColor
            self.addSubview(notification!)
        }
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
        if photo!.seen {
            notification?.removeFromSuperview()
        }
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
