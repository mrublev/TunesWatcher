//
//  RegionsTableViewController.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 29/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import UIKit

class RegionsTableViewController: UITableViewController {
    
    var objects: [CountryRecord]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var appIdEntry: AppIdEntry?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let json = loadJsonFile() {
            objects = makeListFromJsonObjects(json).sorted(by: { (left, right) -> Bool in
                return left.readableName.compare(right.readableName) == ComparisonResult.orderedAscending
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func loadJsonFile() -> Any? {
        if let filePath = Bundle.main.path(forResource: "countries", ofType: "json") {
            if let data = try? Data.init(contentsOf:URL.init(fileURLWithPath: filePath)) {
                if let object = try? JSONSerialization.jsonObject(with: data) {
                    return object
                }
            }
        }
        return nil;
    }
    
    func makeListFromJsonObjects(_ object: Any) -> [CountryRecord] {
        var allCounties = [CountryRecord]()
        (object as! [String: String]).forEach { (key: String, value: String) in
            let record = CountryRecord()
            record.shortName = key
            record.readableName = value
            allCounties.append(record)
        }
        return allCounties
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects == nil ? 0 : objects!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)

        let object = objects![indexPath.row]
        cell.textLabel?.text = object.readableName

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowComments" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = segue.destination as! CommentsViewController
                controller.appIdEntry = appIdEntry
                controller.regionShort = objects![indexPath.row].shortName
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}
