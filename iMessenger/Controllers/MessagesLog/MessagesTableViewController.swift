//
//  MessegesTableViewController.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/28/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import Firebase
import CoreData
class MessagesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var user: User!
    var messages: [Message] = []
    var messageDict: [String: Message] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        self.configureUI()
        checkLoggedInState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }
    
    func setupController(){
        messages.removeAll()
        messageDict.removeAll()
        tableView.reloadData()
        observeUserMessages()
        tableView.reloadData()
        self.navigationItem.title = user?.name
    }

    // Check if user logged in and fetch their data
    func checkLoggedInState(){
        if (Firebase.Auth.auth().currentUser == nil) {
            logout()
            return
        }
        
        FirebaseClient.fetchUserData(completion:{ user in
            guard user != nil else {
                self.logout()
                return
            }
            self.user = user
            DispatchQueue.main.async {
                self.navigationItem.title = user?.name
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func logout(){
        FirebaseClient.signOut()
        self.performSegue(withIdentifier: "login", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            let loginVC = segue.destination as! LoginViewController
            loginVC.messagesVC = self
        }
    }
    
    @objc func newMessage(){
        self.performSegue(withIdentifier: "newMessage", sender: nil)
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
            
                    self.messageDict[message.chatPartnerID()] = message
                    self.messages = Array(self.messageDict.values)
                    self.messages.sort(by: { (message1, message2) -> Bool in
                        return message1.dateSent!.toDate(dateFormat: "yy-MM-dd HH:mm:ss") >
                            message2.dateSent!.toDate(dateFormat: "yy-MM-dd HH:mm:ss")
                    })
                }
                    
                    //Causes Images Glitches as not all messages should be displayed
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

            })
        })
    }
    
    
    func showChatControllerForUser(message: Message){
        let user = User()
        user.userID = message.chatPartnerID()
        
        let ref = Firebase.Database.database().reference().child("users").child(user.userID!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: String] else{
                return
            }
            
            user.setValuesForKeys(dict)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatVC.user = user
            self.navigationController?.pushViewController(chatVC, animated: true)
        })
    }
    
    ///////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showChatControllerForUser(message: messages[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell")! as! UserTableViewCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
