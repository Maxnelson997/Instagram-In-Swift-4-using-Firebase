//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/25/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            formatAndInjectCommentData()
        }
    }
    
    fileprivate func formatAndInjectCommentData() {
        guard let comment = self.comment else { return }
        //load profile image
        userProfileImageView.loadImage(urlString: comment.user.profileImageUrl)
        //setup comment text, username && date comment was posted
        let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        guard let postDate = comment.creationDate else { commentLabel.attributedText = attributedText; return }
        let timeAgoDisplay = postDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: "\n" + timeAgoDisplay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        commentLabel.attributedText = attributedText
    }
    
    let userProfileImageView:CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40/2
        iv.backgroundColor = .red
        return iv
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

//    let timeLabel: UIButton = {
//        let u = UIButton(type: .system)
//        u.setTitle("1 week ago", for: .normal)
//        u.setTitleColor(.gray, for: .normal)
//        return u
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        

        addSubview(commentLabel)
        addSubview(userProfileImageView)
    
        commentLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 40, height: 40)
//        timeLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 100, height: 44)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
