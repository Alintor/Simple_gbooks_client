
import UIKit

class FavoriteBooksVC: BooksVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    func loadData() {
        NetworkService.getBooks(request: Requests.favoriteList) { (result) in
            switch result {
            case .success(let value):
                self.books = value
                self.tableVew.reloadData()
            case .failure(let errorText):
                AlertManager.showErrorMessage(errorText, sender: self)
            }
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        Authorization.shared.logout()
        self.navigationController?.popViewController(animated: true)
    }
    

}
