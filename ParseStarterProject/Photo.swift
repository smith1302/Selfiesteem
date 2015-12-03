//
//  Photo.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class Photo : PFObject, PFSubclassing  {
    
    @NSManaged var photoFile: PFFile
    @NSManaged var userID: String
    @NSManaged var ratings: PFRelation
    @NSManaged var averageRating: Int
    @NSManaged var numberOfRatings: Int
    @NSManaged var mostRecentRating: NSDate
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Photos"
    }
    
    func hasUnreadRatings(callback:(Bool)->Void) {
        let query = ratings.query()
        if query == nil {
            callback(false)
            return
        }
        query!.whereKey("seen", equalTo: false)
        query!.findObjectsInBackgroundWithBlock({
            (objects:[PFObject]?, error:NSError?) in
            if objects == nil || objects?.count < 1 {
                callback(false)
                return
            }
            callback(true)
        })
    }
    
    func addRating(rating:Rating) {
        ratings.addObject(rating)
        let newNumberOfRatings = numberOfRatings+1
        let newAverage = (averageRating*numberOfRatings + rating.rating)/newNumberOfRatings
        averageRating = newAverage
        numberOfRatings = newNumberOfRatings
        mostRecentRating = NSDate()
        saveEventually({
            (success:Bool, error:NSError?) in
            if success {
                Rating.sendPushToRatingReceiver(self.userID)
            }
        })
    }
    
}