//
//  MasterViewController.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 29/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import UIKit
import RealmSwift

class RecordsViewController: UITableViewController {

    var detailViewController: RegionsTableViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "Your watch list"

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddNewApplicationVC))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? RegionsTableViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }

    @objc func openAddNewApplicationVC(_ sender: Any) {
        let alert = UIAlertController.init(title: "Select option", message: "You can add application identifier manually or by searching in iTunes", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Manually", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "ShowAddAppId", sender: sender)
        }))
        alert.addAction(UIAlertAction.init(title: "Search", style: .default, handler: { (_) in
            self.performSegue(withIdentifier: "ShowSearchApp", sender: sender)
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let realm = try! Realm()
                let object = realm.objects(AppIdEntry.self)[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! RegionsTableViewController
                controller.appIdEntry = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm();
        return realm.objects(AppIdEntry.self).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let realm = try! Realm();
        
        let object = realm.objects(AppIdEntry.self)[indexPath.row]
        if let name = object.applicationName {
            cell.textLabel!.text = "\(name) (\(object.applicationId))"
        } else {
            cell.textLabel!.text = object.applicationId
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let realm = try! Realm();
            let object = realm.objects(AppIdEntry.self)[indexPath.row]
            try! realm.write {
                realm.delete(object)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

