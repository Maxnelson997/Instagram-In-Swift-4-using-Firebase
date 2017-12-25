//
//  User.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/23/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import UIKit

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
}
