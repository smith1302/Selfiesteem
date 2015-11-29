//
//  Rating.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/12/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class Rating : PFObject, PFSubclassing {
    
    @NSManaged var rating: Int
    @NSManaged var comment: String
    @NSManaged var rater: String
    @NSManaged var photo: Photo
    @NSManaged var photoID: String // So we dont need to load the full photo object
    var successfulSave:Bool = true
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Ratings"
    }
    
    class func submitRating(rating:Int, comment:String?, forPhoto:Photo, callback: (Bool)->Void) {
        if User.currentUser() == nil || forPhoto.objectId == nil {
            ErrorHandler.showAlert("Could not submit rating")
            callback(false)
            return
        }
        let ratingObject = Rating(className: "Ratings")
        ratingObject.rater = User.currentUser()!.objectId!
        ratingObject.rating = rating
        ratingObject.photo = forPhoto
        ratingObject.photoID = forPhoto.objectId!
        if let assertedComment = comment {
            ratingObject.comment = assertedComment
        }
        ratingObject.saveInBackgroundWithBlock({
            (success:Bool, error:NSError?) -> Void in
            if success {
                forPhoto.addRating(ratingObject)
                forPhoto.saveEventually()
                callback(true)
            } else {
                ErrorHandler.showAlert("Rating failed to save...")
                callback(false)
            }
            ratingObject.successfulSave = success
        })
        User.currentUser()!.addRatingToHistory(forPhoto.objectId!, rating: ratingObject)
    }
    
}