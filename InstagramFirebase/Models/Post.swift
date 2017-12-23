//
//  Post.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/22/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import Foundation

struct Post {
    var imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
