//
//  MessageTableViewCell.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/29/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell {

    let padding: CGFloat = 10
    let textPadding: CGFloat = 5

    var textView = UITextView()
    var bubbleView = UIView()
    var profileImageView = UIImageView()
    
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?

    var message: Message? {
        didSet {
            textView.text = message?.messageString
            setNeedsLayout()
        }
    }
    
    func setupProfileImage(uid: String){
        let ref = Firebase.Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                let imageURL = dict["imageURL"] as? String
                self.profileImageView.loadImageUsingCacheWithURLString(url: imageURL ?? "")
            }
        })
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "MessageTableViewCell")
        backgroundColor = .clear
        selectionStyle = .none
        
        bubbleView = UIView()
        bubbleView.layer.cornerRadius =  20
        bubbleView.clipsToBounds = true
        bubbleView.backgroundColor = .appleBlue()
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleView)
        
        textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .white
        textView.backgroundColor = .clear
        contentView.addSubview(textView)
        
        profileImageView = UIImageView()
        profileImageView.image = #imageLiteral(resourceName: "profilePicturePlaceholder")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileImageView)
        
        
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textPadding).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding)
        bubbleViewLeftAnchor =  bubbleView.leftAnchor.constraint( equalTo: profileImageView.rightAnchor, constant: textPadding)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = 0.5 * (self.profileImageView.bounds.size.width)
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: (padding)).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -(padding*2)).isActive = true
        
        textView.topAnchor.constraint(equalTo: self.bubbleView.topAnchor, constant: 3).isActive = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: padding).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -padding).isActive = true
        textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -textPadding).isActive = true
    }
}
