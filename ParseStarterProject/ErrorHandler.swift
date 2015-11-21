
import UIKit

class ErrorHandler {
    static func showAlert(var error:String?) {
        if error == nil {
            error = "Something went wrong!"
        }
        let alert = UIAlertView(title: "Alert", message: error, delegate: self, cancelButtonTitle: "Ok")
        alert.show()
    }
}
