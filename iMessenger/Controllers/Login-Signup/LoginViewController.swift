//
//  LoginViewController.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/27/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var messagesVC: MessagesTableViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        configureUI()
    }
    
    //////////////////////////////////////////////////////
    // MARK: - Log in Authentication
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else{
                showAlert(title: "Login Failed", message: "Enter Username and Password", presentCompletion: nil)
                return
        }
        
        setLogginIn(true)
        LoginAuth(email, password)
    }
    
    func LoginAuth(_ email: String, _ password: String) {
        FirebaseClient.loginAuth(email: email, password: password, completion: { response, error in
            guard error == nil else{
                self.setLogginIn(false)
                self.showAlert(title: "Error", message: error!.localizedDescription, presentCompletion: nil)
                return
            }
            
            self.fetchUserData()
        })
    }
    
    //Load User Data and Login
    func fetchUserData() {
        setLogginIn(false)
        FirebaseClient.fetchUserData(){ user in
            guard user != nil else {
                self.showAlert(title: "Error", message: "Please try again later", presentCompletion: nil)
                return
            }

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let messagesVC = storyBoard.instantiateViewController(withIdentifier: "MessagesTableViewController") as! MessagesTableViewController
            DispatchQueue.main.async {
                self.messagesVC?.user = user
                self.messagesVC?.setupController()
                self.navigationController?.popToRootViewController(animated: true);
            }
        }
    }
}

