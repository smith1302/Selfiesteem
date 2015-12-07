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
    var scrollingHitBottom:Bool = false
    var activityIndictator:ActivityIndictator?
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        self.parseClassName = "Photos"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = UInt(numCols)*3
        
    }
    
    /*
    * Query for a list of photos.
    *   - Sorted by ratings, less to more.
    *   - Does not include our photos.
    */
    override func queryForCollection() -> PFQuery {
        // Get ratings we made less than 24 hours ago
        let ratingsPreviouslyMade = User.currentUser()!.ratings
        let ratingsQuery = ratingsPreviouslyMade.query()
        ratingsQuery?.whereKey("createdAt", greaterThan: NSDate(timeIntervalSinceNow: -60*60*24))
        
        let photosQuery = Photo.query()
        // ~~~~~ Uncomment when done testing
        if !Constants.testMode {
            photosQuery?.whereKey("userID", notEqualTo: User.currentUser()!.objectId!)
            photosQuery?.whereKey("createdAt", greaterThan: NSDate(timeIntervalSinceNow: -60*60*24))
        }
        photosQuery?.orderByAscending("ratingCount")
        photosQuery?.cachePolicy = PFCachePolicy.CacheElseNetwork
        photosQuery?.whereKey("objectId", doesNotMatchKey: "photoID", inQuery: ratingsQuery!)
        photosQuery?.limit = Int(numCols)*8
        return photosQuery!
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().statusBarHidden=false
        checkForRatingUpdates()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.backgroundColor = UIColor.whiteColor()
        //self.navigationItem.titleView = Helper.makeNavTitleView()
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
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let objectCount = objects.count
        if section == 0 {
            return min(objectCount, Int(numCols))
        } else {
            return max(objects.count-Int(numCols),0)
        }
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        if indexPath?.section == 1 {
            let lastIndex = self.objects.count-1
            let newIndexPath = NSIndexPath(forRow: lastIndex-indexPath!.row, inSection: 1)
            return super.objectAtIndexPath(newIndexPath)
        } else {
            return super.objectAtIndexPath(indexPath)
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
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            var header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as? HeaderView
            if header == nil {
                header = HeaderView()
            }
            if indexPath.section == 0 {
                header!.configure("POPULAR")
            } else {
                header!.configure("RECENT")
            }
            return header!
        } else {
            return super.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, atIndexPath: indexPath)
        }
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
    
    // MARK: Scroll Delegate
    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        let minimumTrigger = scrollView.bounds.size.height + 0
//        if scrollView.contentSize.height > minimumTrigger {
//            let distanceFromBottom = scrollView.contentSize.height - (scrollView.bounds.size.height - scrollView.contentInset.bottom) - scrollView.contentOffset.y
//            if distanceFromBottom < 0 && !scrollingHitBottom {
//                self.loadNextPage()
//                scrollingHitBottom = true
//            } else if distanceFromBottom > 10 && scrollingHitBottom {
//                scrollingHitBottom = false
//            }
//        }
//    }
    
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
