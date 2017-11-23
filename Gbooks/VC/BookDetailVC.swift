
import UIKit

class BookDetailVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorsLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var favoriteBtn: UIBarButtonItem!
    
    var book:Book!
    var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        titleLbl.text = book.title
        authorsLbl.text = book.authors.joined(separator: " ")
        descriptionLbl.text = book.desc
        bookImage.kf.indicatorType = .activity
        bookImage.kf.setImage(with: book.imageLink)
        
        NetworkService.isBookFavorite(bookId: book.id) { (isFavorite) in
            self.isFavorite = isFavorite
            self.refreshFavoriteButtonIcon()
        }
    }
    
    func refreshFavoriteButtonIcon() {
        if isFavorite {
            favoriteBtn.image = UIImage(named: "icn_favorite_sel")
        } else {
            favoriteBtn.image = UIImage(named: "icn_favorite_unsel")
        }
    }

    @IBAction func favoriteBtnAction(_ sender: Any) {
        Authorization.shared.authorizedAccess(sender: self) {
            let request:Requests
            if self.isFavorite {
                request = Requests.removeBookFromFavorite(bookId: self.book.id)
            } else {
                request = Requests.addBookToFavorite(bookId: self.book.id)
            }
            NetworkService.manageFavoriteBook(request: request, completion: { (result) in
                if case let .failure(error) = result {
                    AlertManager.showErrorMessage(error, sender: self)
                }
            })
            self.isFavorite = !self.isFavorite
            self.refreshFavoriteButtonIcon()
        }
    }
    
    @IBAction func previewAction(_ sender: Any) {
        self.performSegue(withIdentifier: String(describing: WebVC.self), sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: WebVC.self) {
            if let navVC = segue.destination as? UINavigationController,
                let webVC = navVC.topViewController as? WebVC {
                webVC.link = book.previewLink
            }
        }
    }
    
}
