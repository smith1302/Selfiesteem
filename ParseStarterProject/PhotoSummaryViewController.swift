//
//  PhotoSummaryViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PhotoSummaryViewController: UIViewController {

    var photo:Photo!
    @IBOutlet weak var cachedImageView: CachedPFImageView!
    @IBOutlet weak var commentsDragButton: UIButton!
    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var draggableViewHConstraint: NSLayoutConstraint!
    var draggableTopLayoutConstraint: NSLayoutConstraint!
    var isDraggingView:Bool = false
    var ratingsAreOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Either loads it or uses the cached version
        cachedImageView.file = photo.photoFile
        cachedImageView.loadInBackground()
        
        commentsDragButton.userInteractionEnabled = false
        draggableTopLayoutConstraint = NSLayoutConstraint(item: draggableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        if let childTableVC = self.childViewControllers.first as? PhotoSummaryTableViewController {
            childTableVC.setUpWithPhoto(photo)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpWithPhoto(photo:Photo!) {
        self.photo = photo
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let absoluteButtonFrame = CGRectMake(draggableView.frame.origin.x, draggableView.frame.origin.y, commentsDragButton.frame.size.width, commentsDragButton.frame.size.height)
            isDraggingView = CGRectContainsPoint(absoluteButtonFrame, touch.locationInView(self.view))
            
            // Close the view if we are just tapping on the pic
            if !isDraggingView && !ratingsAreOpen {
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isDraggingView {
            return
        }
        
        if let touch = touches.first {
            let location = touch.locationInView(self.view)
            self.view.removeConstraint(draggableTopLayoutConstraint!)
            draggableViewHConstraint.constant = max(commentsDragButton.frame.size.height,  self.view.frame.size.height-location.y)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isDraggingView {
            let viewHeight = self.view.frame.size.height
            // Make it easier to close if already open, and easier to open if already closed
            let snapToTopThreshold = (ratingsAreOpen) ? viewHeight*4/5 : viewHeight/5
            // If we want to snap it to the top
            if draggableViewHConstraint.constant >= snapToTopThreshold {
                snapDraggableViewToTop()
            } else {
                snapDraggableViewToBottom()
            }
        }
        isDraggingView = false
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        isDraggingView = false
    }
    
    func snapDraggableViewToTop() {
        ratingsAreOpen = true
        self.view.addConstraint(draggableTopLayoutConstraint!)
        // Mark any notifications as seen
        photo.setSeen()
    }
    
    func snapDraggableViewToBottom() {
        ratingsAreOpen = false
        self.view.removeConstraint(draggableTopLayoutConstraint!)
        draggableViewHConstraint.constant = commentsDragButton.frame.size.height
        draggableView.addConstraint(draggableViewHConstraint!)
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
