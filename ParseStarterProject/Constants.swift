import UIKit

class Constants {
    static let appName = "Selfiesteem"
    static let storyboard = UIStoryboard(name: "Main", bundle: nil) //  Get storyboars singleton instance
}

extension NSDate {
    func calenderComponentDifference(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> NSDateComponents {
        let calendar = NSCalendar.currentCalendar()
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        
        var fromDate: NSDate?, toDate: NSDate?
        
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        return difference
    }
}