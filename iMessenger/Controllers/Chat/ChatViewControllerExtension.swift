//
//  ChatViewControllerExtension.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/29/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

extension ChatViewController{
    
    //////////////////////////////////////////////////////
    // MARK: - UI
    
    func configureUI() {
        textField.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        
        
        self.navigationItem.title = user?.name
        tableview.separatorColor = .clear
        
        // Change corners to be round
        textField.layer.cornerRadius = 25
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor =  UIColor(white: 1, alpha: 1).cgColor
        textField.layer.masksToBounds = true
        
        // Add Padding to the left and right of the text
        textField.setPaddingPoints(15)
        
        mediaButton.imageView?.contentMode = .scaleAspectFit
        mediaButton.imageView?.tintColor = .appleBlue()
    }
    
    // Subscribe to Show/Hide Keyboard
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Unubscribe from Show/Hide Keyboard
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // If Editing Bottom Text Field Push the View Up to it wont Hide the Text Field
    @objc func keyboardWillShow(_ notification:Notification) {
        print(getKeyboardHeight(notification))
        print(view.frame.origin.y)
        view.frame.origin.y -= getKeyboardHeight(notification)
        print(view.frame.origin.y)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //Return View to Original Position After Keyboard is Hidden
    @objc func keyboardWillHide(_ notification:Notification) {
        print(getKeyboardHeight(notification))
        print(view.frame.origin.y)
        view.frame.origin.y += getKeyboardHeight(notification)
        print(view.frame.origin.y)
    }
}
