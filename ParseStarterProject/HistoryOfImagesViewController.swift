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
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        // Configure the PFQueryTableView
        self.parseClassName = "User"
        self.textKey = "username"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 20
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
        
        var query:PFQuery = PFQuery()
        
        query = PFQuery(className: "_User")

        query.orderByAscending("username")
        
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? PFTableViewCell
        
        if cell == nil {
            cell = PFTableViewCell()
        }
        
        if let nameEnglish = object?["username"] as? String {
            cell!.textLabel?.text = nameEnglish
        }
        
        return cell!
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
