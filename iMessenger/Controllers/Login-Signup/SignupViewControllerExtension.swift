//
//  SignupViewControllerExtension.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/27/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    //////////////////////////////////////////////////////
    // MARK: - UI
    
    func configureUI(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .appleBlue()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        // Change corners to be round
        nameTextField.layer.cornerRadius = 25
        nameTextField.layer.borderWidth = 2.0
        nameTextField.layer.borderColor =  UIColor(white: 1, alpha: 1).cgColor
        nameTextField.layer.masksToBounds = true
        
        
        emailTextField.layer.cornerRadius = 25
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor =  UIColor(white: 1, alpha: 1).cgColor
        emailTextField.layer.masksToBounds = true
        
        
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.borderColor =  UIColor(white: 1, alpha: 1).cgColor
        passwordTextField.layer.masksToBounds = true
        
        
        signupButton.layer.cornerRadius = 25
        signupButton.layer.borderWidth = 2.0
        signupButton.layer.masksToBounds = true
        signupButton.layer.borderColor =  UIColor(white: 1.0, alpha: 0).cgColor
        
        
        imageButton.layer.cornerRadius = 0.5 * imageButton.bounds.size.width
        imageButton.clipsToBounds = true
        
        
        // Add Padding to the left and right of the text
        emailTextField.setPaddingPoints(15)
        passwordTextField.setPaddingPoints(15)
        nameTextField.setPaddingPoints(15)
    }

    
    // Hides KeyBoard after Returning from Editing Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Show Network Activity
    func setSigningUp(_ signingUp: Bool){
        if signingUp{
            activityIndicator.startAnimating()
            nameTextField.isEnabled = false
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            signupButton.isEnabled = false
            signupButton.alpha = 0.5
        }else{
            activityIndicator.stopAnimating()
            nameTextField.isEnabled = true
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            signupButton.isEnabled = true
            signupButton.alpha = 1.0
        }
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
