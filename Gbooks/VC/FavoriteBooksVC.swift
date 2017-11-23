
import UIKit

class FavoriteBooksVC: BooksVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: Constants.Notifications.favoriteChanged, object: nil)
        emptyView.configure(title: "Your favorite books will be displayed here", image: UIImage(named: "favorite_book")!)
        updateData()

    }

    @objc func updateData() {
        NetworkService.getBooks(request: Requests.favoriteList) { (result) in
            switch result {
            case .success(let value):
                self.books = value
                self.tableVew.reloadData()
                self.refreshEmptyView()
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
