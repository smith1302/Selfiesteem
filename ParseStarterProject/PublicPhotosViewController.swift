//
//  ShowImagesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Eric Smith on 10/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

private let reuseIdentifier = "Cell"

class PublicPhotosViewController: PFQueryCollectionViewController {
    
    let insetSize:CGFloat = 0
    let numCols:CGFloat = 3
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        // Configure the PFQueryTableView
        self.parseClassName = "Photos"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 20
    }
    
    /*
    * Query for a list of photos.
    *   - Sorted by ratings, less to more.
    *   - Does not include our photos.
    */
    override func queryForCollection() -> PFQuery {
        // Get a list of all photos (besides ours).
        let photosQuery = PFQuery(className: "Photos")
        // ~~~~~ Uncomment when done testing
        //photosQuery.whereKey("userID", notEqualTo: PFUser.currentUser()!.objectId!)
        photosQuery.orderByAscending("ratingCount")
        return photosQuery
    }
    
    override func viewWillAppear(animated: Bool) {
        var newFrame = self.collectionView!.frame
        newFrame.size.height = self.view.frame.size.height - 20
        newFrame.origin.y = 20
        self.collectionView!.frame = newFrame
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: PFQueryCollectionView Methods
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PublicPhotoCollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PublicPhotoCollectionViewCell
        if let photoFile = object?["photoFile"] as? PFFile {
            cell.configure(photoFile)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return insetSize
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return insetSize
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(insetSize, insetSize, insetSize, insetSize)
    }
    
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = self.view.frame.size.width
        let columnWidth = screenWidth/self.numCols
        return CGSizeMake(columnWidth, columnWidth)
    }
    
}
