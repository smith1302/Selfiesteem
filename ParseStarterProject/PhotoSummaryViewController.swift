//
//  PhotoSummaryViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PhotoSummaryViewController: UIViewController {
    
    enum Direction {
        case Up;
        case Down;
        case Still;
    }

    var photo:Photo!
    @IBOutlet weak var arrowIndicator: UIButton!
    @IBOutlet weak var cachedImageView: CachedPFImageView!
    @IBOutlet weak var commentsDragButton: UIButton!
    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var draggableViewHConstraint: NSLayoutConstraint!
    var draggableTopLayoutConstraint: NSLayoutConstraint!
    var prevDraggingY:CGFloat!
    var dragDirection:Direction = Direction.Still
    var isDraggingView:Bool = false
    var ratingsAreOpen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.offsetInPlace(dx: 0, dy: 20)
        // Either loads it or uses the cached version
        cachedImageView.file = photo.photoFile
        cachedImageView.loadInBackground()
        
        commentsDragButton.userInteractionEnabled = false
        draggableTopLayoutConstraint = NSLayoutConstraint(item: draggableView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        
        prevDraggingY = draggableView.frame.origin.y
        
        if let childTableVC = self.childViewControllers.first as? PhotoSummaryTableViewController {
            childTableVC.setUpWithPhoto(photo)
        }
        
        setArrowIndicatorImage("Up.png")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden=true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
            dragDirection = .Still
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
            if location.y < prevDraggingY {
                dragDirection = .Up
            } else if location.y > prevDraggingY {
                dragDirection = .Down
            } else {
                dragDirection = .Still
            }
            prevDraggingY = location.y
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            //let viewHeight = self.view.frame.size.height
            //let snapToTopThreshold = viewHeight/2
            // If we want to snap it to the top
//            if draggableViewHConstraint.constant >= snapToTopThreshold {
//                snapDraggableViewToTop()
//            } else {
//                snapDraggableViewToBottom()
//            }
        if dragDirection == .Down {
            snapDraggableViewToBottom()
        } else if dragDirection == .Up {
            snapDraggableViewToTop()
        } else if ratingsAreOpen {
            snapDraggableViewToBottom()
        } else {
            snapDraggableViewToTop()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        isDraggingView = false
    }
    
    func snapDraggableViewToTop() {
        ratingsAreOpen = true
        self.view.addConstraint(draggableTopLayoutConstraint!)
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
        setArrowIndicatorImage("Down.png")
    }
    
    func snapDraggableViewToBottom() {
        ratingsAreOpen = false
        self.view.removeConstraint(draggableTopLayoutConstraint!)
        draggableViewHConstraint.constant = commentsDragButton.frame.size.height
        draggableView.addConstraint(draggableViewHConstraint!)
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
            self.draggableView.layoutIfNeeded()
        }
        setArrowIndicatorImage("Up.png")
    }
    
    func setArrowIndicatorImage(imageName:String) {
        let img = UIImage(named: imageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        arrowIndicator.setImage(img, forState: UIControlState.Normal)
        arrowIndicator.tintColor = UIColor(white: 0.5, alpha: 1)
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
