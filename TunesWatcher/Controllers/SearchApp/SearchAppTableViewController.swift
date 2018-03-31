//
//  SearchAppTableViewController.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 30/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class SearchAppTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    let AppStoreSearchTemplate = "https://itunes.apple.com/search?term=<TERM>&country=us&entity=software"
    var objects: [SearchAppEntry]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects == nil ? 0 : objects!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAppCell", for: indexPath)

        let object = objects![indexPath.row]
        cell.textLabel?.text = object.title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let object = objects![indexPath.row]
        let appEntry = AppIdEntry()
        appEntry.applicationId = object.appId
        appEntry.applicationName = object.title
        
        if let realm = try? Realm() {
            try! realm.write {
                realm.add(appEntry)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - SearchBar delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            return
        }
        
        let urlString = AppStoreSearchTemplate.replacingOccurrences(of: "<TERM>", with: searchText)
        if let url = URL(string: urlString) {
            Alamofire.request(url).responseJSON { response in
                if let json = response.result.value {
                    self.objects = self.processJsonResponse(json as! [String: Any])
                } else {
                    self.objects = nil
                }
            }
        }
    }
    
    // MARK: - Private
    
    func processJsonResponse(_ jsonObject: [String: Any]) -> [SearchAppEntry] {
        var allEntries = [SearchAppEntry]()
        if let resultsList = jsonObject["results"] as? [[String: Any]] {
            resultsList.forEach { (resultsItem: [String: Any]) in
                let entry = SearchAppEntry()
                if let trackName = resultsItem["trackName"] as? String {
                    entry.title = trackName
                }
                if let url = resultsItem["trackViewUrl"] as? String {
                    entry.urlString = url
                }
                if let appId = resultsItem["trackId"] as? Int {
                    entry.appId = String(appId)
                }
                allEntries.append(entry)
            }
        }
        return allEntries
    }
}
