//
//  NewMessagesViewControllerExtension.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/29/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

extension NewMessageTableViewController{
    
    func configureUI() {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewMessage))
        self.navigationItem.leftBarButtonItem  = cancelBarButtonItem
        
        self.tableView.separatorColor = .clear
        
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
    }
}
