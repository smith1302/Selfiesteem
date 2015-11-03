//
//  CachedPFImageView.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI

class CachedPFImageView : PFImageView {
    
    // Override the functionality to check if its in the cache
    override var file: PFFile? {
        get {
            return super.file
        }
        set {
            // If its in the cache, set the image
            if let nonNilFile = newValue, image = Cache.imageCache[nonNilFile] {
                super.image = image
            }
            super.file = file
        }
    }
    
    // Only do a load if we don't have the cached image.
    override func loadInBackground() -> BFTask {
        if super.image == nil {
            // It's important to use the completion block method here to ensure we cache the image when loaded.
            self.loadInBackground(nil)
        }
        return BFTask(result: nil)
    }
    
    override func loadInBackground(completion: PFImageViewImageResultBlock?) {
        self.loadInBackground(completion, progressBlock: nil)
    }
    
    // When a load is complete, store it in the cache
    override func loadInBackground(completion: PFImageViewImageResultBlock?, progressBlock: ((Int32) -> Void)?) {
        let completionWithCache = {
            (image:UIImage?, error:NSError?) -> Void in
            if self.file != nil {
                Cache.imageCache[self.file!] = image
            }
            completion?(image, error)
        }
        super.loadInBackground(completionWithCache, progressBlock: progressBlock)
    }
}