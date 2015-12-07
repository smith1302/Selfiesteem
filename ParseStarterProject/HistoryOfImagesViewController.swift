//
//  HistoryOfImagesViewController.swift
//  Selfiesteem
//
//  Created by David  Yeung on 10/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HistoryOfImagesViewController: CustomPFQueryTableViewController {
    let kRecentIndex = 0
    let kBestIndex = 1
    var defaultCell:PFTableViewCell?
    var scrollingHitBottom:Bool = false
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        customInit()
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        customInit()
    }
    
    func customInit() {
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.parseClassName = "_Users"
        self.objectsPerPage = 7
        self.loadingViewEnabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false // Sets the Navbar to be seen when loaded
        UIApplication.sharedApplication().statusBarHidden=false
        updateCellSeenStates()
        self.navigationItem.hidesBackButton = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func queryForTable() -> PFQuery {
        let userID = PFUser.currentUser()?.objectId

        var query:PFQuery = PFQuery()
        
        query = PFQuery(className: "Photos")
        query.whereKey("userID", equalTo: userID!)
        query.whereKey("createdAt", greaterThan: NSDate(timeIntervalSinceNow: -60*60*24*7))
        query.cachePolicy = PFCachePolicy.CacheThenNetwork
        if segmentControl.selectedSegmentIndex == kRecentIndex {
            query.orderByDescending("updatedAt")
        } else {
            query.orderByDescending("averageRating")
        }
        
        return query
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath?) -> PFObject? {
        if self.objects?.count != 0 {
            return super.objectAtIndexPath(indexPath)
        }
        return PFObject(className: "Users")
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objects?.count != 0 {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        if object?.objectId != nil {
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ImagePostCell!
            if(cell == nil) {
                cell = ImagePostCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            }
            if let photo = object as? Photo {
                cell.configure(photo)
            }else {
                print("Unable to do it")
            }
            
            return cell
        } else {
            defaultCell = tableView.dequeueReusableCellWithIdentifier("EmptyCell", forIndexPath: indexPath) as? PFTableViewCell
            if hasFinishedInitialLoad {
                defaultCell?.textLabel?.text = "You don't have any selfies yet!"
            }
            defaultCell!.textLabel?.textColor = UIColor(white: 0.4, alpha: 1)
            return defaultCell!
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < self.objects?.count {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        } else {
            return 55
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if let object = objectAtIndexPath(indexPath) {
                // Delete all ratings associated with it
                let query = Rating.query()
                query?.whereKey("photoID", equalTo: object.objectId!)
                query?.findObjectsInBackgroundWithBlock({
                    (objects:[PFObject]?, error:NSError?) in
                    if objects == nil {
                        return
                    }
                    for object in objects! {
                        object.deleteEventually()
                    }
                })
            }
            removeObjectAtIndexPath(indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, cellForNextPageAtIndexPath indexPath: NSIndexPath) -> PFTableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("EmptyCell", forIndexPath: indexPath) as? PFTableViewCell
        //cell!.textLabel!.text = "Loading..."
        //cell!.textLabel?.textAlignment = .Center
        cell?.hidden = true
        return cell
    }
    
    func updateCellSeenStates() {
        for cell in tableView.visibleCells{
            if let imageCell = cell as? ImagePostCell {
                imageCell.updateSeenState()
            }
        }
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let minimumTrigger = scrollView.bounds.size.height + 0
        if scrollView.contentSize.height > minimumTrigger {
            let distanceFromBottom = scrollView.contentSize.height - (scrollView.bounds.size.height - scrollView.contentInset.bottom) - scrollView.contentOffset.y
            if distanceFromBottom < 0 && !scrollingHitBottom {
                self.loadNextPage()
                scrollingHitBottom = true
            } else if distanceFromBottom > 10 && scrollingHitBottom {
                scrollingHitBottom = false
            }
        }
    }
    
    //Clicked on a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < self.objects?.count {
            performSegueWithIdentifier("toPhotoSummaryVC", sender: tableView.cellForRowAtIndexPath(indexPath))
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    
    @IBAction func segmentControlValueChanged(sender: AnyObject) {
        self.loadObjects()
    }
    
    @IBAction func toCamera(sender: AnyObject) {
        self.performSegueWithIdentifier("returnToCameraLeftSegue", sender: self)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let photoSummaryVC = segue.destinationViewController as? PhotoSummaryViewController, selectedCell = sender as? ImagePostCell {
            let photo = selectedCell.photo
            photoSummaryVC.setUpWithPhoto(photo)
        }
    }
}
