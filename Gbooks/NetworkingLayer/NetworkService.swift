
enum Result<T> {
    case success(T)
    case failure(String)
}

import Alamofire
import SwiftyJSON

struct NetworkService {
    
    static func getBooks(request: Requests, completion: @escaping (Result<[Book]>) -> Void){
        
        Alamofire.request(request).responseJSON(completionHandler: { response in
            
            switch(response.result){
                
            case let .success(value):
                
                let books: [Book] = parseBooks(json: JSON(value))
                
                completion(Result.success(books))
                
            case let .failure(error):
                completion(Result.failure(error.localizedDescription))
                
            }
        })
    }
    
    static func manageFavoriteBook(request: URLRequestConvertible, completion: @escaping (Result<String>) -> Void){
        Alamofire.request(request).responseJSON(completionHandler: { response in
            
            switch(response.result){
                
            case .success:
                
                completion(Result.success("Success"))
                
            case let .failure(error):
                completion(Result.failure(error.localizedDescription))
                
            }
        })
    }
    
    private static func parseBooks(json: JSON) -> [Book]{
        
        guard let  json = json[NetworkingConstants.items].array else{
            return []
        }
        
        return json.flatMap(Book.init)
    }
    
}
