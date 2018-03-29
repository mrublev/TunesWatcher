//
//  EnterAppstoreIDViewController.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 29/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import UIKit
import RealmSwift

class EnterAppstoreIDViewController: UIViewController {

    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addNewObject(_:)))
    }

    @objc func addNewObject(_ sender: Any) {
        if let text = textField.text {
            let appEntry = AppIdEntry();
            appEntry.applicationId = text;
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(appEntry);
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
