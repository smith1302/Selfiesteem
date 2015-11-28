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
    @NSManaged var ratings: [Rating]
    @NSManaged var averageRating: Int
    @NSManaged var numberOfRatings: Int
    @NSManaged var seen: Bool // If a new rating on this photo has been seen or not
    
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
    
    func addRating(rating:Rating) {
        ratings.append(rating)
        let newNumberOfRatings = numberOfRatings+1
        let newAverage = (averageRating*numberOfRatings + rating.rating)/newNumberOfRatings
        averageRating = newAverage
        numberOfRatings = newNumberOfRatings
        seen = false
    }
    
    func setSeen() {
        if !seen {
            seen = true
            saveEventually()
        }
    }
    
}