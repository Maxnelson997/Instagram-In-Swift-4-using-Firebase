//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Max Nelson on 12/24/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .cyan
        iv.layer.cornerRadius = 50/2
        return iv
    }()
    
    let userLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.boldSystemFont(ofSize: 14)
        let attributedText = NSMutableAttributedString(string: "u-name", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\n", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 1)]))
        attributedText.append(NSAttributedString(string: "4 posts", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        l.attributedText = attributedText
        l.numberOfLines = 0
        return l
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(userLabel)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        userLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        let grayLine = UIView()
        grayLine.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(grayLine)
        grayLine.anchor(top: nil, left: userLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
