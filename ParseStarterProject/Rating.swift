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
    
    static let kPushRatingMessage = "Someone rated your selfie!"
    
    @NSManaged var rating: Int
    @NSManaged var comment: String
    @NSManaged var rater: String
    @NSManaged var photo: Photo
    @NSManaged var photoID: String // So we dont need to load the full photo object
    @NSManaged var seen: Bool
    @NSManaged var forUserID: String
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
    
    func setSeen() {
        if !seen {
            seen = true
            saveEventually()
        }
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
        ratingObject.seen = false
        ratingObject.photo = forPhoto
        ratingObject.forUserID = forPhoto.userID
        ratingObject.photoID = forPhoto.objectId!
        ratingObject.ACL?.setPublicWriteAccess(true)
        if let assertedComment = comment {
            ratingObject.comment = assertedComment
        }
        ratingObject.saveEventually({
            (success:Bool, error:NSError?) -> Void in
            if success {
                forPhoto.addRating(ratingObject)
                callback(true)
                User.increaseUnreadRatingForUserWithID(forPhoto.userID)
            } else {
                ErrorHandler.showAlert("Rating failed to save.")
                callback(false)
            }
            ratingObject.successfulSave = success
        })
        User.currentUser()!.addRatingToHistory(forPhoto.objectId!, rating: ratingObject)
    }
    
    class func sendPushToRatingReceiver(userID:String) {
        let data = [
            "alert": kPushRatingMessage,
            "badge": "Increment",
            "sound": "default",
            "title": Constants.appName
        ]
        let push = PFPush()
        push.setChannel(userID)
        push.setData(data)
        push.sendPushInBackground()
    }
    
}