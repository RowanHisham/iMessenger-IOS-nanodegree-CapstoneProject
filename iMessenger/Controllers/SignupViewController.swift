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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func signupButtonClicked(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text else{
                print("Please Enter The Requested Information")
                showAlert(title: "Sign Up Failed!", message: "Please enter the requested information to create an account", presentCompletion: nil)
                return
        }
        
        
        Firebase.Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user: Firebase.AuthDataResult?, error) in

            guard error == nil, let user = user?.user else{
//                self.showAlert(title: "Error", message: "Sign Up Failed, Try Again Later!")
                self.showAlert(title: "Error", message: error!.localizedDescription, presentCompletion: nil)

                return
            }
            
            let ref = Firebase.Database.database(url: "https://imessenger-f1d02.firebaseio.com/").reference()
            
            let usersRef = ref.child("users").child(user.uid)
            let values = ["name":name, "email":email]
            usersRef.updateChildValues(values, withCompletionBlock: { error, ref in
                guard error == nil else{
                print(error?.localizedDescription)
                return
                }
            })
            
            self.showAlert(title: "Account Created", message: "Return to the previous page and login", presentCompletion: self.handleSignUpCompleted)
        })
    }
    
    func handleSignUpCompleted(_ action: UIAlertAction){
        self.navigationController?.popToRootViewController(animated: true);
    }
    
    ///////////////////////////////////////////////////////////
    // MARK: - Image Picker
    
    @IBAction func chooseImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    // Save Image Picked and dismiss the Picker View
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            self.userImage = image
            self.imageButton.setImage(image, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
