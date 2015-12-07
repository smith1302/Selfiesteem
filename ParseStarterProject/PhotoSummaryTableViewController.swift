//
//  PhotoSummaryTableViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/21/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PhotoSummaryTableViewController: CustomPFQueryTableViewController {
    // Initialise the PFQueryTable tableview
    
    var photo:Photo?
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        self.loadingViewEnabled = false
        self.parseClassName = "Ratings"
    }
    
    required init(coder aDecoder:NSCoder)
    {
        super.init(coder: aDecoder)!
        //fatalError("NSCoding not supported")
    }
    
    func setUpWithPhoto(photo:Photo) {
        self.photo = photo
        self.loadObjects()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(white: 0.2, alpha: 0.85)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.separatorColor = UIColor.clearColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        var query:PFQuery = PFQuery()
        if let photo = photo {
            query = PFQuery(className: "Ratings")
            query.whereKey("photoID", equalTo: photo.objectId!)
            query.orderByDescending("createdAt")
        }
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PhotoRatingCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! PhotoRatingCell!
        if(cell == nil) {
            cell = PhotoRatingCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        if let rating = object as? Rating {
            cell.configure(rating)
        }else {
            ErrorHandler.showAlert("Couldn't cast PFQueryObject to Rating")
        }
        return cell
    }
}
