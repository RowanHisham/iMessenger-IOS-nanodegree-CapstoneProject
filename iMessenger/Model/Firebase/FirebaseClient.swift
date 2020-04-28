//
//  FirebaseClient.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/28/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import Firebase

class FirebaseClient{
    
    func fetchUserData(completion: (UserData)-> Void){
        let uid = Firebase.Auth.auth().currentUser!.uid
        Firebase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            let user = 
            completion(snapshot.value as! [String: AnyObject])
        })
    }
}
