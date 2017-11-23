
import UIKit
import Kingfisher

protocol BookCellDelegate {
    func showBookPreview(previewURL: URL)
    func isFavoriteBook(bookId:String, callback:@escaping (Bool)->())
    func manageFavoriteBook(bookId:String, isFavorite:Bool, callback:@escaping ()->())
}

class BookCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorsLbl: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var bookId:String!
    var previewURL: URL!
    var delegate:BookCellDelegate!
    var isFavorite = false
    
    override func awakeFromNib() {
        favoriteBtn.tintColor = UIColor(red: 126.0/255.0, green: 54.0/255.0, blue: 26.0/255.0, alpha: 1)
    }
    
    func refreshFavoriteButtonIcon() {
        if isFavorite {
            favoriteBtn.setImage(UIImage(named: "icn_favorite_sel"), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: "icn_favorite_unsel"), for: .normal)
        }
    }
    
    
    @IBAction func favoriteAction(_ sender: Any) {
        
        delegate.manageFavoriteBook(bookId: bookId, isFavorite: isFavorite) {
            self.isFavorite = !self.isFavorite
            self.refreshFavoriteButtonIcon()
        }
    }
    
    @IBAction func previewAction(_ sender: Any) {
        delegate.showBookPreview(previewURL: previewURL)
    }
    
    func configureCell(book: Book, delegate:BookCellDelegate) {
        titleLbl.text = book.title
        authorsLbl.text = book.authors.joined(separator: "\n")
        bookImage.kf.indicatorType = .activity
        bookImage.kf.setImage(with: book.imageLink)
        bookId = book.id
        previewURL = book.previewLink
        self.delegate = delegate
        delegate.isFavoriteBook(bookId: book.id) { (isFavorite) in
            self.isFavorite = isFavorite
            self.refreshFavoriteButtonIcon()
        }
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
