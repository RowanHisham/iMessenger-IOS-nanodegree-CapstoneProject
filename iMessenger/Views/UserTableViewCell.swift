//
//  UserTableViewCell.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/28/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {

    let padding: CGFloat = 10
    var userImage = UIImageView()
    var nameLabel = UILabel()
    var messageLabel = UILabel()
    var timeLabel = UILabel()
    
    var user: User? {
        didSet {
            userImage.loadImageUsingCacheWithURLString(url: user?.imageURL ?? "")
            nameLabel.text = user?.name
            messageLabel.text = user?.email
            timeLabel.text = ""
            setNeedsLayout()
            }
        }
    
    var message: Message? {
        didSet {
            setupNameandProfileImage()
            messageLabel.text = message?.messageString
            let date = message?.dateSent?.toDate(dateFormat: "yy-MM-dd HH:mm:ss")
            let dateStr = date?.toString(dateFormat: "HH:mm a")
            timeLabel.text = dateStr
            setNeedsLayout()
            }
    }
    
    func setupNameandProfileImage(){
        
        let ref = Firebase.Database.database().reference().child("users").child(message!.chatPartnerID())
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                self.nameLabel.text = dict["name"] as? String
                let imageURL = dict["imageURL"] as? String
                self.userImage.loadImageUsingCacheWithURLString(url: imageURL ?? "")
            }
        })
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "UserTableViewCell")
        backgroundColor = .white
        selectionStyle = .none
    
        nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = .black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        contentView.addSubview(nameLabel)
        
        messageLabel = UILabel()
        messageLabel.textAlignment = .left
        messageLabel.textColor = .darkGray
        messageLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(messageLabel)
        
        timeLabel = UILabel()
        timeLabel.textAlignment = .left
        timeLabel.textColor = .gray
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(timeLabel)
        
        userImage = UIImageView()
        userImage.image = #imageLiteral(resourceName: "profilePicturePlaceholder")
        contentView.addSubview(userImage)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImage.frame = CGRect(x: padding, y: padding, width: frame.height - 2 * padding, height:
            frame.height - 2 * padding)
        userImage.layer.cornerRadius = 0.5 * (self.userImage.bounds.size.width)
        userImage.clipsToBounds = true
        
        
        nameLabel.frame = CGRect(x: 2*padding + (frame.height - 2 * padding) , y: padding*2, width: frame.width - (2*padding + (frame.height - 2 * padding)), height: 15)
        
        
        messageLabel.frame = CGRect(x:  2*padding + (frame.height - 2 * padding) , y: padding*2 + 20, width: frame.width - (frame.height + 2 * padding) - 50, height: 15)
        
        timeLabel.frame = CGRect(x: frame.width - (2*padding + 50) , y: padding*2 + 20, width: 50+(2*padding), height: 15)
    }
}

