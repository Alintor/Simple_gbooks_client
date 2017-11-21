//
//  ViewController.swift
//  Gbooks
//
//  Created by Alexandr Ovchinnikov on 21.11.17.
//  Copyright © 2017 Alexandr Ovchinnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func qwe(_ sender: Any) {
        
        Authorization.shared.authorizedAccess(sender: self) {
            print("Test")
        }

    }
    
}

