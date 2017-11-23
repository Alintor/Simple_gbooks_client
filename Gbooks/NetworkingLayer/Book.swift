

import UIKit
import SwiftyJSON

class Book: NSObject {
    var id:String
    var title:String
    var authors:[String]
    var desc:String
    var imageLink:URL
    var previewLink:URL
    
    init?(json: JSON) {
        guard
            let title = json["volumeInfo"]["title"].string,
            let authors = json["volumeInfo"]["authors"].arrayObject as? [String],
            let desc = json["volumeInfo"]["description"].string,
            let imageLink = json["volumeInfo"]["imageLinks"]["thumbnail"].url,
            let previewLink = json["volumeInfo"]["previewLink"].url,
            let id = json["id"].string
        
        else {
            return nil
        }
        self.id = id
        self.title = title
        self.authors = authors
        self.desc = desc
        self.imageLink = imageLink
        self.previewLink = previewLink
    }

}
