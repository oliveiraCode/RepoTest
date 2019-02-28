//
//  ViewController Extensions.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-23.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(errorCode: AuthErrorCode){
        
        let alert = UIAlertController(title: FirebaseAuthErrors.warning, message: "", preferredStyle: .alert)
        
        switch errorCode {
        case .emailAlreadyInUse:
            alert.message = FirebaseAuthErrors.emailAlreadyInUse
            break
        case .invalidEmail:
            alert.message = FirebaseAuthErrors.invalidEmail
            break
        case .wrongPassword:
            alert.message = FirebaseAuthErrors.wrongPassword
            break
        case .weakPassword:
            alert.message = FirebaseAuthErrors.weakPassword
            break
        case .userNotFound:
            alert.message = FirebaseAuthErrors.userNotFound
            break
        case .userDisabled:
            alert.message = FirebaseAuthErrors.userDisabled
            break
        case .networkError:
            alert.message = FirebaseAuthErrors.networkError
            break
        // TODO: A case for if the password field is blank
        default:
            alert.message = FirebaseAuthErrors.errorDefault
        }
        
        alert.addAction(UIAlertAction(title: General.OK, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func showAlert(title:String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
