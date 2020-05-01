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
    
    
    static func createUser(email: String, password: String, completion:  @escaping (AuthDataResult?,Error?)-> Void){
        Firebase.Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    static func uploadImage(data: Data?, completion: @escaping (String?, Error?)-> Void ){
        guard data != nil else{
            completion("", nil)
            return
        }
        let imageName = NSUUID().uuidString
        let storageRef = Firebase.Storage.storage().reference().child(imageName)
        storageRef.putData(data!, metadata: nil, completion: { metadata, error in
            guard error == nil else{
                completion("", error)
                return
            }
            storageRef.downloadURL(completion: { url, error in
                guard error == nil else{
                    completion("", error)
                    return
                }
                if let urlText = url?.absoluteString {
                    completion(urlText,nil)
                }
            })
        })
    }
    
    static func regiesterUserInDatabase(user: User, completion: @escaping (Error?, DatabaseReference)->Void){
        let ref = Firebase.Database.database().reference()
        
        let usersRef = ref.child("users").child(user.userID!)
        let values = ["name":user.name, "email":user.email, "imageURL": user.imageURL ?? ""]
        usersRef.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: completion)
    }
    
    
    static func loginAuth(email: String, password: String, completion: @escaping (AuthDataResult?,Error?)-> Void){
        Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func fetchUserData(completion: @escaping (User?)-> Void){
        let uid = Firebase.Auth.auth().currentUser!.uid
        Firebase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in

            
            guard let dict = snapshot.value as? [String: AnyObject] else {
                completion(nil)
                return
            }
            
            let user = User()
            user.name = dict["name"] as? String
            user.email =  dict["email"] as? String
            user.imageURL = dict["imageURL"] as? String
            user.userID = snapshot.key
            
            completion(user)
        })
    }
    
    static func fetchUsersData(completion: @escaping ([String: AnyObject?])-> Void){
        Firebase.Database.database().reference().child("users").observe( .childAdded, with: { snapshot in
            var dict = snapshot.value as! [String: AnyObject]
            dict["userID"] = snapshot.key as AnyObject
            completion(dict)
        })
    }
    
    static func downloadImage(imageURL: String?, completion: @escaping (Data?, Error?)-> Void ){
        guard imageURL != nil else{
            return
        }
        
        let request = URLRequest(url: URL(string: imageURL!)!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil, data != nil else{
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    static func signOut(){
        try? Firebase.Auth.auth().signOut()
    }
    
    static func sendMessage(message: Message){
    
        let ref = Firebase.Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["messageString":message.messageString!,
                      "toID": message.toID!,
                      "fromID": message.fromID!,
                      "dateSent": message.dateSent!]
        childRef.updateChildValues(values){ (error,ref) in
            guard error == nil else{
                return
            }
            
            let senderMessageRef = Firebase.Database.database().reference().child("user-messages").child(message.fromID!)
            let recipentMessageRef = Firebase.Database.database().reference().child("user-messages").child(message.toID!)
            
            let messageID = childRef.key!
            
            senderMessageRef.updateChildValues([messageID: 1])
            recipentMessageRef.updateChildValues([messageID: 1])
        }
    }
}
