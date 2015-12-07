import Parse

class User : PFUser {
    // Photo objectID : rating
    var ratingsHistoryCache:[String:Rating] = [String:Rating]()
    @NSManaged var ratings:PFRelation
    @NSManaged var unreadRatings: Int // So we dont have to load all the user's photos and child ratings just to get read state
    @NSManaged var mostRecentSelfie:NSDate
    @NSManaged var selfiesToday:Int
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    // Our ratings cache makes a few assumptions:
    // 1. If the cache doesn't exist, we need to get data from parse
    // 2. If it does exist, we aren't missing anything so we don't need to pull from parse
    
    func getRatingForPhoto(photo:Photo?, callback: (Rating?)->Void) {
        if photo == nil {
            callback(nil)
            return
        }
        let photoID = photo!.objectId!
        let query = ratings.query()
        query?.whereKey("photoID", equalTo: photoID)
        query?.getFirstObjectInBackgroundWithBlock({
            (rating:PFObject?, error:NSError?) in
            callback(rating as? Rating)
        })
    }
    
    func addRatingToHistory(rating:Rating) {
        ratings.addObject(rating)
        saveEventually()
    }
    
    func readRating(rating:Rating) {
        if unreadRatings > 0 {
            unreadRatings--
            saveEventually()
        }
        rating.setSeen()
    }
    
    func unreadRatings(callback:(Int)->Void) {
        let query = Rating.query()
        if query == nil {
            callback(0)
            return
        }
        query?.whereKey("forUserID", equalTo: objectId!)
        query?.whereKey("seen", equalTo: false)
        query?.whereKey("createdAt", greaterThan: NSDate(timeIntervalSinceNow: -60*60*24*6))
        query?.findObjectsInBackgroundWithBlock({
            (objects:[PFObject]?, error:NSError?) in
            if objects == nil {
                callback(0)
                return
            }
            callback(objects!.count)
        })
    }
    
    class func increaseUnreadRatingForUserWithID(id:String) {
        // Get user with ID, then increase their unread ratings
        let query = User.query()
        query?.whereKey("objectId", equalTo: id)
        query?.getFirstObjectInBackgroundWithBlock({
            (object:PFObject?, error:NSError?) in
            if let user = object as? User {
                user.unreadRatings++
                user.saveEventually()
            }
        })
    }
    
//    private func getRatingsHistoryFromParse(callback:(Void)->Void) {
//        let oneDayAgo = NSDate(timeIntervalSinceNow: -60*60*24)
//        let query = PFQuery(className: "Ratings")
//        query.whereKey("rater", equalTo: User.currentUser()!.objectId!)
//        // Not necessary to get ratings that are old because the pic is expired anyways
//        query.whereKey("createdAt", greaterThanOrEqualTo: oneDayAgo)
//        query.findObjectsInBackgroundWithBlock({
//            (ratings:[PFObject]?, error:NSError?) in
//            self.ratingsHistory = [String:Rating]()
//            for rating in ratings as! [Rating] {
//                self.ratingsHistory![rating.photoID] = rating
//            }
//            callback()
//        })
//    }
    
    override static func currentUser() -> User? {
        return PFUser.currentUser() as? User
    }
}