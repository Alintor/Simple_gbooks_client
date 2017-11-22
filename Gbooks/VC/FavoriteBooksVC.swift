//
//  FavoriteBooksVC.swift
//  Gbooks
//
//  Created by Alexandr Ovchinnikov on 22.11.17.
//  Copyright © 2017 Alexandr Ovchinnikov. All rights reserved.
//

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
                break
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
