//
//  DetailViewController.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 29/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class CommentsViewController: UITableViewController {
    
    let URLTemplate = "https://itunes.apple.com/<REGION>/rss/customerreviews/id=<APP_ID>/sortBy=mostRecent/json"
    var requestURL: URL?
    var objects: [FeedComment]?
    
    var appIdEntry: AppIdEntry?
    var regionShort: String?
    
    func getApplicationURL() -> URL? {
        if let region = regionShort, let id = appIdEntry?.applicationId {
            let requestString: String = URLTemplate.replacingOccurrences(of: "<APP_ID>", with: id).replacingOccurrences(of: "<REGION>", with: region)
            return URL.init(string: requestString)
        }
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = getApplicationURL() {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            Alamofire.request(url).responseJSON { response in
                if let json = response.result.value {
                    self.processJson(json as! [String: Any])
                }
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.tableView.reloadData()
            }
        }
    }
    
    func processJson(_ feed: [String: Any]) {
        if let feedUnwrap = feed["feed"] as? [String: Any] {
            if let commentEntries = feedUnwrap["entry"] as? [[String: Any]] {
                var allComments = [FeedComment]()
                
                commentEntries.forEach({ (entry: [String: Any]) in
                    if entry["author"] != nil {
                        allComments.append(commentForEntry(entry))
                    }
                })
                objects = allComments
            }
        }
    }
    
    func commentForEntry(_ entry: [String: Any]) -> FeedComment {
        let comment = FeedComment()
        if let authorDict = entry["author"] as? [String: Any], let nameDict = authorDict["name"] as? [String: Any], let label = nameDict["label"] as? String  {
            comment.authorName = label
        }
        if let ratingDict = entry["im:rating"] as? [String: Any], let label = ratingDict["label"] as? String {
            comment.rating = label
        }
        if let titleDict = entry["title"] as? [String: Any], let label = titleDict["label"] as? String {
            comment.title = label
        }
        if let contentDict = entry["content"] as? [String: Any], let label = contentDict["label"] as? String {
            comment.content = label
        }
        return comment
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects == nil ? 0 : objects!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let object = objects![indexPath.row]
        
        cell.ratingLabel.text = object.rating
        cell.titleLabel.text = object.title
        cell.descriptionLabel.text = object.content

        return cell
    }
}

