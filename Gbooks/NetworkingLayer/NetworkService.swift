//MARK: - Response data
enum Result<T> {
    case success(T)
    case failure(String)
}

import Alamofire
import SwiftyJSON

struct NetworkService {
    
    //MARK: - Support methods
    private static func parseBooks(json: JSON) -> [Book]{
        guard let  json = json[Constants.Networking.items].array else{
            return []
        }
        return json.flatMap(Book.init)
    }
    
    //MARK: - Public methods
    static func isBookFavorite(bookId:String, completion: @escaping (Bool)->Void) {
        Authorization.shared.checkTokenValidation { (isValid) in
            guard isValid else {
                completion(false)
                return
            }
            
            getBooks(request: Requests.favoriteList) { (result) in
                switch result {
                case let .failure(error):
                    print(error)
                    completion(false)
                case let .success(books):
                    let contains = books.contains(where: { (book) -> Bool in
                        book.id == bookId
                    })
                    completion(contains)
                }
            }
        }
    }
    
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
        
        Alamofire.request(request).response { (response) in
            if let error = response.error {
                completion(Result.failure(error.localizedDescription))
            } else {
                NotificationCenter.default.post(name: Constants.Notifications.favoriteChanged, object: nil)
                completion(Result.success("Success"))
            }
        }
    }
    
    
}
