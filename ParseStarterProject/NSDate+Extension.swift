//
//  NSDate+Extension.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/23/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation

extension NSDate {
    
    public var timeAgo: String {
        let components = self.dateComponents()
        
        if components.year > 0 {
            if components.year < 2 {
                return "Last year"
            } else {
                return stringFromFormat("%d years ago", withValue: components.year)
            }
        }
        
        if components.month > 0 {
            if components.month < 2 {
                return "Last month"
            } else {
                return stringFromFormat("%d months ago", withValue: components.month)
            }
        }
        
        // TODO: localize for other calanders
        if components.day >= 7 {
            let week = components.day/7
            if week < 2 {
                return "Last week"
            } else {
                return stringFromFormat("%d weeks ago", withValue: week)
            }
        }
        
        if components.day > 0 {
            if components.day < 2 {
                return "Yesterday"
            } else  {
                return stringFromFormat("%d days ago", withValue: components.day)
            }
        }
        
        if components.hour > 0 {
            if components.hour < 2 {
                return "An hour ago"
            } else  {
                return stringFromFormat("%d hours ago", withValue: components.hour)
            }
        }
        
        if components.minute > 0 {
            if components.minute < 2 {
                return "A minute ago"
            } else {
                return stringFromFormat("%d minutes ago", withValue: components.minute)
            }
        }
        
        if components.second > 0 {
            if components.second < 5 {
                return "Just now"
            } else {
                return stringFromFormat("%d seconds ago", withValue: components.second)
            }
        }
        
        return ""
    }
    
    private func dateComponents() -> NSDateComponents {
        let calander = NSCalendar.currentCalendar()
        return calander.components([.Second, .Minute, .Hour, .Day, .Month, .Year], fromDate: self, toDate: NSDate(), options: [])
    }
    
    private func stringFromFormat(format: String, withValue value: Int) -> String {
        return String(format: format, value)
    }
    
}