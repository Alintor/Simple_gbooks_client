
import Foundation
import Alamofire

enum Requests: URLRequestConvertible {
    case searchBook(bookName: String)
    case favoriteList
    case addBookToFavorite(bookId: String)
    case removeBookFromFavorite(bookId: String)
    
    var path: String {
        
        switch self {
        case .searchBook:
            return NetworkingConstants.volumes
            
        case .favoriteList:
            return NetworkingConstants.favorites + NetworkingConstants.volumes
            
        case .addBookToFavorite:
            return NetworkingConstants.favorites + NetworkingConstants.addValume
            
        case .removeBookFromFavorite:
            return NetworkingConstants.favorites + NetworkingConstants.removeValume
        }
    }
    
    var parameters: [String: Any] {
        
        var paramDict : [String: Any] = [:]
        
        switch self {
        case .searchBook(let bookName):
            paramDict[NetworkingConstants.searchString] = bookName
        case .addBookToFavorite(let bookId), .removeBookFromFavorite(let bookId):
            paramDict[NetworkingConstants.volumeId] = bookId
            
        default:
            break
        }
        
        return paramDict
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchBook, .favoriteList:
            return .get
            
        case .addBookToFavorite, .removeBookFromFavorite:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        
        var headers : [String:String] = [:]
        
        if Authorization.shared.isTokenValid() {
            headers[NetworkingConstants.authorization] = "Bearer " + Authorization.shared.token!
        }
        
        return headers
        
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkingConstants.baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return try URLEncoding.methodDependent.encode(urlRequest, with: parameters)
    }
}
