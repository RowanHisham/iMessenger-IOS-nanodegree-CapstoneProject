//
//  Message.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/30/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import Firebase

@objcMembers
class Message: NSObject{
    var fromID: String?
    var toID: String?
    var messageString: String?
    var dateSent: String?
    
    func chatPartnerID() -> String {
        return fromID == (Firebase.Auth.auth().currentUser?.uid) ? toID! : fromID!
    }
}
