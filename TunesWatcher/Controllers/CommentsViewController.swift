//
//  DetailViewController.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 29/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import UIKit
import RealmSwift

class CommentsViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var appIdEntry: AppIdEntry? {
        didSet {
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let appEntry = appIdEntry {
            if let label = detailDescriptionLabel {
                label.text = appEntry.applicationId
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

