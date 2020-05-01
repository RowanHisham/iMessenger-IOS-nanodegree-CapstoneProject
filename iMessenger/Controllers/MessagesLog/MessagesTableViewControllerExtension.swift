//
//  MessagesTableViewControllerExtension.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/28/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

extension MessagesTableViewController{
    
    //////////////////////////////////////////////////////
    // MARK: - UI
    
    func configureUI(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .appleBlue()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessage))
        
        navigationController?.navigationItem.leftBarButtonItem  = logoutBarButtonItem
        navigationController?.navigationItem.rightBarButtonItem = addBarButtonItem
        
        self.navigationItem.leftBarButtonItem = logoutBarButtonItem
        self.navigationItem.rightBarButtonItem = addBarButtonItem
    }
}
