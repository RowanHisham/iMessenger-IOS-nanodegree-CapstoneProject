//
//  UIViewControllerExtension.swift
//  iMessenger
//
//  Created by Rowan Hisham on 4/28/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    //Display Error Message to the User
    func showAlert(title: String, message: String, presentCompletion: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: presentCompletion)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
