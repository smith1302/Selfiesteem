import UIKit
import CoreGraphics

class Constants {
    static let appName = "Selfiesteem"
    static let storyboard = UIStoryboard(name: "Main", bundle: nil) //  Get storyboars singleton instance
    static let primaryColor = UIColor(netHex: 0x55B34B)
    static let darkPrimaryColor = UIColor(netHex: 0x4B9E42)
    static let lightPrimaryColor = UIColor(netHex: 0xABE8A5)
    static let secondaryColor = UIColor(netHex: 0x84EEFA)
    class func primaryColorWithAlpha(alpha:CGFloat) -> UIColor {
        return UIColor(netHex: 0x55B34B, alpha: alpha)
    }
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

extension UIColor {
    convenience init(netHex:Int) {
        self.init(netHex: netHex, alpha: 1)
    }
    
    convenience init(netHex:Int, alpha:CGFloat) {
        let red = (netHex >> 16) & 0xff
        let green = (netHex >> 8) & 0xff
        let blue = netHex & 0xff
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

extension String {
    func hasWhitespace() -> Bool {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        let range = self.rangeOfCharacterFromSet(whitespace)
        return range != nil
    }
    
    func stripWhitespace() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}