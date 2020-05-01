//
//  SignupViewController.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/27/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
 
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userImage: UIImage? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        configureUI()
    }

    
    //////////////////////////////////////////////////////
    // MARK: - Sign Up
    
    @IBAction func signupButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else {
                showAlert(title: "Sign Up Failed!", message: "Please enter the requested information to create an account", presentCompletion: nil)
                return
        }
        
        // Regiester User Credintials
        setSigningUp(true)
        FirebaseClient.createUser(email: email, password: password, completion:{ response, error in
            guard error == nil, let userData = response?.user else{
                self.setSigningUp(false)
                self.showAlert(title: "Error", message: error!.localizedDescription, presentCompletion: nil)
                return
            }
            
            // Upload Profile Image
            let uploadData = self.userImage?.jpegData(compressionQuality: 0.1)
            FirebaseClient.uploadImage(data: uploadData, completion: { url, error in
                let user = User()
                user.name = name
                user.email = email
                user.imageURL = url
                user.userID = userData.uid
                self.registerUser(user: user)
                })
        })
    }
    
    // Update User Data in Database
    func registerUser(user: User){
        FirebaseClient.regiesterUserInDatabase(user: user, completion: { error, ref in
            self.setSigningUp(false)
            guard error == nil else{
                return
            }
            self.showAlert(title: "Account Created", message: "Account Created Succesfully!", presentCompletion: self.handleSignUpCompleted)
        })
    }
    
    //Return to Login View
    func handleSignUpCompleted(_ action: UIAlertAction){
        self.navigationController?.popViewController(animated: true)
    }

}
