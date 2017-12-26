//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/25/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import Foundation

struct Comment {
    
    var user: User
    let text: String
    let uid: String
    var creationDate: Date?
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
