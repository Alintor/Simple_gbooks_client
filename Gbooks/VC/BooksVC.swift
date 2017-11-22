//
//  BooksVC.swift
//  Gbooks
//
//  Created by Alexandr Ovchinnikov on 22.11.17.
//  Copyright © 2017 Alexandr Ovchinnikov. All rights reserved.
//

import UIKit

class BooksVC: UIViewController {
    
    @IBOutlet weak var tableVew: UITableView!
    var books = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableVew.registerReusableCell(BookCell.self)
    }
    
    
     // MARK: - Navigation
     

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: WebVC.self) {
            if let navVC = segue.destination as? UINavigationController,
                let webVC = navVC.topViewController as? WebVC,
                let link = sender as? URL {
                webVC.link = link
            }
        }
        
        if segue.identifier == String(describing: BookDetailVC.self) {
            if let bookDetailVC = segue.destination as? BookDetailVC,
                let book = sender as? Book {
                bookDetailVC.book = book
            }
        }
     }
    
}

//MARK: - UITableViewDataSource implementation

extension BooksVC : UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as BookCell
        
        cell.configureCell(book: book, delegate: self)
        return cell
    }
    
}

extension BooksVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        self.performSegue(withIdentifier: String(describing: BookDetailVC.self), sender: book)
    }
}

extension BooksVC : BookCellDelegate {
    func isFavoriteBook(bookId: String, callback: @escaping (Bool) -> ()) {
        NetworkService.isBookFavorite(bookId: bookId) { (isFavorite) in
            callback(isFavorite)
        }
    }
    
    func addToFavorite(bookId: String) {
        NetworkService.manageFavoriteBook(request: Requests.addBookToFavorite(bookId: bookId)) { (result) in
            if case let .failure(error) = result {
                print(error)
            }
        }
    }
    
    func removeFromFavorite(bookId: String) {
        NetworkService.manageFavoriteBook(request: Requests.removeBookFromFavorite(bookId: bookId)) { (result) in
            if case let .failure(error) = result {
                print(error)
            }
        }
    }
    
    func showBookPreview(previewURL: URL) {
        self.performSegue(withIdentifier: String(describing: WebVC.self), sender: previewURL)
    }
}
