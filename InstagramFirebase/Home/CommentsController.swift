//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/25/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationItem.title = "Comments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    lazy var containerView:UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let sendIt = UIButton(type: .system)
        sendIt.setTitle("Submit", for: .normal)
        sendIt.setTitleColor(.black, for: .normal)
        sendIt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendIt.addTarget(self, action: #selector(self.handleSendIt), for: .touchUpInside)
        containerView.addSubview(sendIt)
        sendIt.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        containerView.addSubview(commentTextField)
        commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: sendIt.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Leave a comment"
        return tf
    }()
    
    @objc func handleSendIt() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post?.id else { return }
        let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("error sending comment:", err)
                return
            }
            
            print("successfully inserted a comment into the db")
            
        }
        
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
