//
//  LoginViewController.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/27/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        configureUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else{
                showAlert(title: "Login Failed", message: "Enter Username and Password", presentCompletion: nil)
                return
        }
        
        Firebase.Auth.auth().signIn(withEmail: email, password: password, completion: { (user: Firebase.AuthDataResult?, error) in
            
            guard error == nil else{
                self.showAlert(title: "Error", message: error!.localizedDescription, presentCompletion: nil)
                return
            }
            
            self.fetchUserData()
        })
    }
    
    func fetchUserData() {
        let uid = Firebase.Auth.auth().currentUser!.uid
        Firebase.Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as! [String: AnyObject]?{
                self.performSegue(withIdentifier: "login", sender: dict)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
        if let viewController = segue.destination as? MessegesTableViewController {
            viewController.dict = sender as! [String : AnyObject]
            }
        }
    }
}
