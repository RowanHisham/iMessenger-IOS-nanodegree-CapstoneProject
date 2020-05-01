//
//  ChatViewController.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/29/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var user: User?
    var messages: [Message] = []
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        
        subscribeToKeyboardNotifications()
        configureUI()
        
        messages.removeAll()
        observeUserMessages()
        tableview.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func observeUserMessages(){
        guard let uid = Firebase.Auth.auth().currentUser?.uid else{
            return
        }
        
        let ref = Firebase.Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { snapshot in
            
            let messageID = snapshot.key
            let messageRef = Firebase.Database.database().reference().child("messages").child(messageID)
            
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: String]{
                    let message = Message()
                    message.setValuesForKeys(dict)
                    
                    if message.chatPartnerID() == self.user?.userID{
                        self.messages.append(message)
                    }
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message2.dateSent!.toDate(dateFormat: "yy-MM-dd HH:mm:ss") >
                            message1.dateSent!.toDate(dateFormat: "yy-MM-dd HH:mm:ss")
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    if(self.messages.count > 1){
                        let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                        self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    }
                }
            })
        })
    }
    
    
    // Send Message and hides KeyBoard when send in clicked
    @IBAction func sendButtonClicked(_ sender: Any) {
        sendMessage()
    }
    
    // Send Message and hides KeyBoard after Returning from Editing Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    func sendMessage(){
        guard let messageString = textField.text , messageString != "" else{
            view.endEditing(true)
            return
        }
        
        let message = Message()
        message.messageString = messageString
        message.dateSent = Date().toString(dateFormat: "yy-MM-dd HH:mm:ss")
        message.toID = user?.userID
        message.fromID = Firebase.Auth.auth().currentUser?.uid
        FirebaseClient.sendMessage(message: message)
        textField.text?.removeAll()
        view.endEditing(true)
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell")! as! MessageTableViewCell
        let message = messages[indexPath.row]
        
        if message.fromID == Firebase.Auth.auth().currentUser?.uid{
            // From User - Blue Bubble
            cell.bubbleView.backgroundColor = .appleBlue()
            cell.textView.textColor = .white
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
            cell.profileImageView.isHidden = true
        }else{
            // From Partner - Grey Bubble
            cell.bubbleView.backgroundColor = .bubbleGray()
            cell.textView.textColor = .black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
            cell.setupNameandProfileImage(uid: message.chatPartnerID())
        }
        
        cell.message = message
        return cell
    }
    
    // Calculate text bubble height to fit text
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = messages[indexPath.row].messageString
        let size = CGSize(width: 180, height: 9000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let textSize = NSString(string: text!).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], context: nil)
        return textSize.height + 50
    }
}
