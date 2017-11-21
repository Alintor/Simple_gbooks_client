
import UIKit
import OAuthSwift

class Authorization: NSObject {
    static let shared = Authorization()
    
    static let cliendId = "666948627790-0lde9jp2d2lsp73meeu5f4fjmq5cd695.apps.googleusercontent.com"
    static let secretId = ""
    static let authorizeUrl = "https://accounts.google.com/o/oauth2/auth"
    static let accessTokenUrl = "https://accounts.google.com/o/oauth2/token"
    static let responseType = "code"
    static let callbackURL = "com.googleusercontent.apps.666948627790-0lde9jp2d2lsp73meeu5f4fjmq5cd695:/oauth"
    static let scope = "https://www.googleapis.com/auth/books"
    static let state = "books"
    static let oauthToken = "oauthToken"
    
    let oauthswift: OAuth2Swift
    
    var token: String? {
        didSet {
            UserDefaults.standard.set(token, forKey: Authorization.oauthToken)
        }
    }
    
    override init() {
        oauthswift = OAuth2Swift(consumerKey: Authorization.cliendId,
                                 consumerSecret: Authorization.secretId,
                                 authorizeUrl: Authorization.authorizeUrl,
                                 accessTokenUrl: Authorization.accessTokenUrl,
                                 responseType: Authorization.responseType)
        
        token = UserDefaults.standard.string(forKey: Authorization.oauthToken)
        
    }
    
    func isTokenValid() -> Bool {
        if token != nil {
            return true
        } else {
            return false
        }
    }
    
    func authorizedAccess(sender viewController:UIViewController, action: @escaping ()->()) {
        if isTokenValid() {
            action()
        } else {
            oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: oauthswift)
            oauthswift.authorize(withCallbackURL: Authorization.callbackURL,
                                 scope: Authorization.scope,
                                 state: Authorization.state,
                                 success: { (credentical, response, params) in
                                    self.token = credentical.oauthToken
                                    DispatchQueue.main.async {
                                        action()
                                    }
                                    
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
}
