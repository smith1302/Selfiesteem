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
    
    @NSManaged var objectID: String
    @NSManaged var photoFile: PFFile
    
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
    
}