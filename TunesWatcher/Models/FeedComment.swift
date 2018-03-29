//
//  FeedEntry.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 29/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import Foundation
import RealmSwift

class FeedComment : Object {
    @objc dynamic var authorName: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var rating: String = ""
}
