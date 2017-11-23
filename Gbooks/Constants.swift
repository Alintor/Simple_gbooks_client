import Foundation
struct Constants {
    struct Networking {
        static let baseUrl = "https://www.googleapis.com/books/v1"
        static let volumes = "/volumes"
        static let favorites = "/mylibrary/bookshelves/0"
        static let addValume = "/addVolume"
        static let removeValume = "/removeVolume"
        
        static let volumeId = "volumeId"
        static let searchString = "q"
        static let authorization = "Authorization"
        static let items = "items"
    }
    
    struct Authorization {
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
    }
    
    struct Notifications {
        static let favoriteChanged = NSNotification.Name(rawValue: "favoriteChanged")
    }
}
