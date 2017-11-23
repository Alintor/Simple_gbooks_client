

import UIKit

struct AlertManager {
    
    static func showAuthorizationAlert(sender:UIViewController, action:@escaping ()->()) {
        let title = "Authorization"
        let message = "You need to login to your Google account"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let authAction = UIAlertAction(title: "Login", style: .default) { (alertAction) in
            action()
        }
        alertController.addAction(authAction)
        alertController.addAction(cancelAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    static func showErrorMessage(_ message:String, sender:UIViewController) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        sender.present(alertController, animated: true, completion: nil)
    }
}
