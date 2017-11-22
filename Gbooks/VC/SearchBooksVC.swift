

import UIKit

class SearchBooksVC: BooksVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserDefaults.standard.set(nil, forKey: Authorization.oauthToken)
        
    }

    func searchBooksWith(searchText:String) {
        NetworkService.getBooks(request: Requests.searchBook(bookName: searchText)) { (result) in
            switch result {
            case .success(let value):
                self.books = value
                self.tableVew.reloadData()
            case .failure(let errorText):
                break
            }
        }
    }
    
    @IBAction func favoritesBtnAction(_ sender: Any) {
        
        Authorization.shared.authorizedAccess(sender: self) {
            self.performSegue(withIdentifier: String(describing: FavoriteBooksVC.self), sender: nil)
        }
    }
    
    
    
}

extension SearchBooksVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBooksWith(searchText: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
}
