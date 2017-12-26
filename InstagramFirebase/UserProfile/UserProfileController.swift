//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/20/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cellId:String = "cellid"
    let homePostCellId:String = "homePostCellId"
    var headerId:String = "headerId"
    
    var userId: String?
    
    var isGridView: Bool = true
    var isFinishedPaging:Bool = false
    
    var user: User?
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        fetchUser()
        setupLogoutButton()
    }
    

    fileprivate func fetchUser() {
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        Database.fetchUserWith(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            //reload data to re-execute header size & rendering of header, to feed it a new object.
            self.collectionView?.reloadData()
            
            self.paginatePosts()
        }
    }
    
    @objc fileprivate func paginatePosts() {
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
//
//        let value = "-L1GTmcCl9n7K76C0hEl"
//        let query = ref.queryOrderedByKey().queryStarting(atValue: value).queryLimited(toFirst: 6)
        
//        var query = ref.queryOrderedByKey()

        var query = ref.queryOrdered(byChild: "creationDate")
        
        if posts.count > 0 {
            guard let value = posts.last?.creationDate.timeIntervalSince1970 else { return }
            query = query.queryEnding (atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
           
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            allObjects.reverse()
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 && allObjects.count > 0{
                allObjects.removeFirst()
            }

            guard let user = self.user else { return }
            
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                print(post.id ?? "nig")
                self.posts.append(post)
            })
            self.posts.forEach({ (post) in
                
            })
            self.collectionView?.reloadData()
        }) { (err) in
            print("failed to perform post pagination:",err)
        }
    }
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.insert(post, at: 0)

            self.collectionView?.reloadData()
        }) { (err) in
            print("failed to fetch ordered posts:", err)
        }
    }

    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.handleLogout))
    }
    
    @objc fileprivate func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("perform logout")
            do {
                try Auth.auth().signOut()
            } catch let signOutErr {
                print("failed to sign out:",signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //paginate
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging  {
            print("paginating 4 images/posts")
            paginatePosts()
        }
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            let hw = (view.frame.width - 2) / 3
            return CGSize(width: hw, height: hw)
        }
        var height:CGFloat = 40 + 8 + 8
        //username userprofileimageview
        height += view.frame.width
        height += 50
        //post bottom controls
        height += 60
        //caption
        return CGSize(width: view.frame.width, height: height)
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    

    
    
}

extension UserProfileController: UserProfileHeaderDelegate {
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
    
}
