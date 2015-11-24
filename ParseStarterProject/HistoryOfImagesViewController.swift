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

class HistoryOfImagesViewController: PFQueryTableViewController {
    // Initialise the PFQueryTable tableview
    
    override init(style: UITableViewStyle, className: String!)
    {
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 25
        
        self.parseClassName = "_Users"
    }
    
    required init(coder aDecoder:NSCoder)
    {
         super.init(coder: aDecoder)!
        //fatalError("NSCoding not supported")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false // Sets the Navbar to be seen when loaded
        updateCellSeenStates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func queryForTable() -> PFQuery {
        let userID = PFUser.currentUser()?.objectId
        //print(userID!)

        var query:PFQuery = PFQuery()
        
        query = PFQuery(className: "Photos")
        query.whereKey("userID", equalTo: userID!)
        query.orderByDescending("updatedAt")
        
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> ImagePostCell? {
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
    }
    
    func updateCellSeenStates() {
        for cell in tableView.visibleCells as! [ImagePostCell] {
            cell.updateSeenState()
        }
    }
    
    //Clicked on a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toPhotoSummaryVC", sender: tableView.cellForRowAtIndexPath(indexPath))
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let photoSummaryVC = segue.destinationViewController as? PhotoSummaryViewController, selectedCell = sender as? ImagePostCell {
            let photo = selectedCell.photo
            photoSummaryVC.setUpWithPhoto(photo)
        }
    }
}
