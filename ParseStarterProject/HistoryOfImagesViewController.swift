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


    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBarHidden = false // Sets the Navbar to be seen when loaded
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

        //query.orderByAscending("createdAt")
        
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> ImagePostCell? {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ImagePostCell!
        if(cell == nil) {
            cell = ImagePostCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        if let photoFile = object?["photoFile"] as? PFFile {
            if let labeltext = object?.objectId! {
                cell.configure(photoFile, objectId: labeltext)
            } else {
                cell.configure(photoFile, objectId: "something")

            }
        }else {
            print("Unable to do it")
        }

        
        return cell
    }
    //Clicked on a cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let object = self.objects?[indexPath.row] {
//            let canToggle = User.currentUser()!.toggleFollow(object as? PFUser)
//            if canToggle {
//                let cell = tableView.cellForRowAtIndexPath(indexPath) as! FriendCell!
//                cell.setFollow(!cell.following)
//            }
//        }
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
