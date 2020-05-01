//
//  NewMessegeTableViewController.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/28/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit

class NewMessageTableViewController: UITableViewController {

    var users: [User] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
    }

    // Download Users Data
    func fetchUsers(){
        FirebaseClient.fetchUsersData(completion: { dict in
            let user = User()
            user.name =  (dict["name"] as! String)
            user.email = (dict["email"] as! String)
            user.imageURL = (dict["imageURL"] as! String)
            user.userID = (dict["userID"] as! String)
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func cancelNewMessage(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell")! as! UserTableViewCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //Open chat when row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showChatControllerForUser(user: users[indexPath.row])
    }
    
    //Replace the current view with the chat view
    func showChatControllerForUser(user: User){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.user = user
        //Replace current View with Chat view
        var vcs = navigationController!.viewControllers
        vcs[vcs.count - 1] = chatVC
        navigationController?.setViewControllers(vcs, animated: true)
    }
}

