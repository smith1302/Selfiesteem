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
    let numCols:CGFloat = 4
    
    
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
        self.navigationController?.navigationBarHidden = false
        
        var newFrame = self.collectionView!.frame
        newFrame.size.height = self.view.frame.size.height - 20
        newFrame.origin.y = 20
        self.collectionView!.frame = newFrame
        
        checkForRatingUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Check to see if user has recently rated this photo so we can gray it out
    func checkForRatingUpdates() {
        for cell in  self.collectionView!.visibleCells() {
            if let publicPhotoCollectionViewCell = cell as? PublicPhotoCollectionViewCell {
                publicPhotoCollectionViewCell.update()
            }
        }
    }
    
    // Mark: PFQueryCollectionView Methods
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PublicPhotoCollectionViewCell? {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PublicPhotoCollectionViewCell
        if let photo = object as? Photo {
            cell.configure(photo)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) {
            if let castedCell = selectedCell as? PublicPhotoCollectionViewCell where castedCell.isInactive() {
                return
            }
            self.performSegueWithIdentifier("toRatePhotoViewController", sender: selectedCell)
        }
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
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
    
    // MARK: Transitions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ratePhotoVC = segue.destinationViewController as? RatePhotoViewController, selectedCell = sender as? PublicPhotoCollectionViewCell {
            let photo = selectedCell.photo
            ratePhotoVC.setUpWithPhoto(photo)
        }
    }
    
}
