//
//  FirebaseDatabaseUtils.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/23/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    static func fetchUserWith(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String : Any]  else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
        }) { (err) in
            print("failed to fetch user for posts:", err)
        }
    }
}
