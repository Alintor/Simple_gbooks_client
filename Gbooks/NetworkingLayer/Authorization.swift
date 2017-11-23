
import UIKit
import OAuthSwift

class Authorization: NSObject {
    static let shared = Authorization()
    
    
    let oauthswift: OAuth2Swift
    
    private(set) var token: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.Authorization.oauthToken)
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.Authorization.oauthToken)
        }
    }
    
    private var refreshToken:String {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.Authorization.oauthRefreshToken)
        }
        get {
            return UserDefaults.standard.string(forKey: Constants.Authorization.oauthRefreshToken)!
        }
    }
    
    private var tokenExpiresDate: Date {
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.Authorization.tokenExpiresDate)
        }
        get {
            return UserDefaults.standard.object(forKey: Constants.Authorization.tokenExpiresDate) as! Date
        }
    }
    
    override init() {
        oauthswift = OAuth2Swift(consumerKey: Constants.Authorization.cliendId,
                                 consumerSecret: Constants.Authorization.secretId,
                                 authorizeUrl: Constants.Authorization.authorizeUrl,
                                 accessTokenUrl: Constants.Authorization.accessTokenUrl,
                                 responseType: Constants.Authorization.responseType)
    }
    
    func isTokenValid() -> Bool {
        if token != nil {
            return true
        } else {
            return false
        }
    }
    
    func logout() {
        self.token = nil
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
                AlertManager.showAuthorizationAlert(sender: viewController, action: {
                    self.oauthswift.authorizeURLHandler = SafariURLHandler(viewController: viewController, oauthSwift: self.oauthswift)
                    self.oauthswift.authorize(withCallbackURL: Constants.Authorization.callbackURL,
                                              scope: Constants.Authorization.scope,
                                              state: Constants.Authorization.state,
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
                })
            }
        }
    }
    
}
