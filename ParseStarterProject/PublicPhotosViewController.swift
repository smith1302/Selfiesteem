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
    var activityIndictator:ActivityIndictator?
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        customInit()
    }
    
    func customInit() {
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.parseClassName = "Photos"
        self.objectsPerPage = 1
        self.loadingViewEnabled = false
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
        photosQuery.cachePolicy = PFCachePolicy.CacheThenNetwork
        photosQuery.whereKey("createdAt", greaterThan: NSDate(timeIntervalSinceNow: -60*60*24))
        return photosQuery
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarHidden=false
        
        checkForRatingUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundColor = UIColor.whiteColor()
    }
    
    override func objectsWillLoad() {
        if activityIndictator != nil {
            return
        }
        super.objectsWillLoad()
        activityIndictator = ActivityIndictator()
        let mainView = UIApplication.sharedApplication().keyWindow
        mainView?.addSubview(self.activityIndictator!)
        activityIndictator?.startAnimating()
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        activityIndictator?.remove({
            self.activityIndictator = nil
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Check to see if user has recently rated this photo so we can gray it out
    func checkForRatingUpdates() {
        for cell in  self.collectionView!.visibleCells() {
            if let publicPhotoCollectionViewCell = cell as? PublicPhotoCollectionViewCell {
                publicPhotoCollectionViewCell.addRatingLabelIfNeeded()
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
        return UIEdgeInsetsMake(insetSize+20, insetSize, insetSize, insetSize)
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
    
    // MARK: Actions
    
    @IBAction func toCamera(sender: AnyObject) {
        self.performSegueWithIdentifier("returnToCameraRightSegue", sender: self)
    }
    
    
}
