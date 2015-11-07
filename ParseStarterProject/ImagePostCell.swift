import ParseUI
import Parse
import UIKit

public class ImagePostCell : PFTableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet var postImage: PFImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: "Cell")
        print("Generic Cell Initialization Done")
    }
    
    func configure(photoFile:PFFile, objectId:String?) {
        if (objectId != nil) {
            label.text = objectId
        }
        //Circular image
        self.postImage.layer.cornerRadius = (self.postImage.frame.size.height)/2

        
        //postImage = PFImageView(frame: CGRectMake(0, 0, 100, 100))
        postImage.image = UIImage(named: "ActivityIndicator.gif")
        postImage.file = photoFile
        postImage.loadInBackground()
        postImage.contentMode = .ScaleToFill
        postImage.backgroundColor = UIColor.grayColor()
    }
    required public init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)!
        //fatalError("init(coder:) has not been implemented")
    }


}
