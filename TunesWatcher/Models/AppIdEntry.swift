//
//  Application.swift
//  TunesWatcher
//
//  Created by Michael Rublev on 29/03/2018.
//  Copyright © 2018 Michael Rublev. All rights reserved.
//

import Foundation
import RealmSwift

class AppIdEntry: Object {
    @objc dynamic var applicationId: String = ""
    @objc dynamic var applicationName: String?
    @objc dynamic var applicationUrlString: String?
}
