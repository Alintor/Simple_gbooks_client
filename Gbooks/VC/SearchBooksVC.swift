

import UIKit

class SearchBooksVC: UIViewController {
    
    @IBOutlet weak var tableVew: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var books = [Book]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVew.registerReusableCell(BookCell.self)
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
    
}

//MARK: - UITableViewDataSource implementation

extension SearchBooksVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as BookCell
        
        cell.titleLbl.text = book.title
        cell.authorsLbl.text = book.authors.first
        
//        if let imageLink = article.imageLink {
//            cell.itemImage.kf.indicatorType = .activity
//            cell.itemImage.kf.setImage(with: URL(string: imageLink))
//            cell.hideImage(false)
//        } else {
//            cell.hideImage(true)
//        }
        return cell
    }
    
}

extension SearchBooksVC : UITableViewDelegate {
}

extension SearchBooksVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBooksWith(searchText: searchText)
    }
}
