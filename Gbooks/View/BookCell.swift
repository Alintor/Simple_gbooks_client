
import UIKit
import Kingfisher

protocol BookCellDelegate {
    func manageFavorite(bookId: String)
    func showBookPreview(previewURL: URL)
}

class BookCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorsLbl: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var bookId:String!
    var previewURL: URL!
    var delegate:BookCellDelegate!
    
    
    
    @IBAction func favoriteAction(_ sender: Any) {
        delegate.manageFavorite(bookId: bookId)
    }
    
    @IBAction func previewAction(_ sender: Any) {
        delegate.showBookPreview(previewURL: previewURL)
    }
    
    func configureCell(book: Book, delegate:BookCellDelegate) {
        titleLbl.text = book.title
        authorsLbl.text = book.authors.first
        bookImage.kf.indicatorType = .activity
        bookImage.kf.setImage(with: book.imageLink)
        bookId = book.id
        previewURL = book.previewLink
        self.delegate = delegate
    }
    
}

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nib: UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}
