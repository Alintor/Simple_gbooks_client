
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
    static let oauthRefreshToken = "oauthRefreshToken"
    static let tokenExpiresDate = "tokenExpiresDate"
    
    let oauthswift: OAuth2Swift
    
    private(set) var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Authorization.oauthToken)
        }
        get {
            return UserDefaults.standard.string(forKey: Authorization.oauthToken)
        }
    }
    
    private var refreshToken:String {
        set {
            UserDefaults.standard.set(newValue, forKey: Authorization.oauthRefreshToken)
        }
        get {
            return UserDefaults.standard.string(forKey: Authorization.oauthRefreshToken)!
        }
    }
    
    private var tokenExpiresDate: Date {
        set {
            UserDefaults.standard.set(newValue, forKey: Authorization.tokenExpiresDate)
        }
        get {
            return UserDefaults.standard.object(forKey: Authorization.tokenExpiresDate) as! Date
        }
        
    }
    
    override init() {
        oauthswift = OAuth2Swift(consumerKey: Authorization.cliendId,
                                 consumerSecret: Authorization.secretId,
                                 authorizeUrl: Authorization.authorizeUrl,
                                 accessTokenUrl: Authorization.accessTokenUrl,
                                 responseType: Authorization.responseType)
        
        
    }
    
    func isTokenValid() -> Bool {
        if token != nil {
            return true
        } else {
            return false
        }
    }
    
    func checkTokenValidation(callback: @escaping (Bool)->()) {
        guard isTokenValid() else {
            callback(false)
            return
        }
        guard Date() > tokenExpiresDate else {
            callback(true)
            return
        }
        
        oauthswift.renewAccessToken(withRefreshToken: refreshToken, success: { (credentical, response, params) in
            self.token = credentical.oauthToken
            self.refreshToken = credentical.oauthRefreshToken
            self.tokenExpiresDate = credentical.oauthTokenExpiresAt!
            callback(true)
        }) { (error) in
            print(error.localizedDescription)
            callback(false)
        }
    }
    
    func authorizedAccess(sender viewController:UIViewController, action: @escaping ()->()) {
        checkTokenValidation { (isValid) in
            if isValid {
                action()
            } else {
                self.oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: self.oauthswift)
                self.oauthswift.authorize(withCallbackURL: Authorization.callbackURL,
                                     scope: Authorization.scope,
                                     state: Authorization.state,
                                     success: { (credentical, response, params) in
                                        self.token = credentical.oauthToken
                                        self.refreshToken = credentical.oauthRefreshToken
                                        self.tokenExpiresDate = credentical.oauthTokenExpiresAt!
                                        DispatchQueue.main.async {
                                            action()
                                        }
                                        
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
