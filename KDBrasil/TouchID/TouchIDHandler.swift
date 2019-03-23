//
//  TouchIDHandler.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-21.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import LocalAuthentication

class TouchIDHandler {
    
    static let shared = TouchIDHandler()
    
    func authenticateUser(completion: @escaping (String?) -> Void) {
        let context = LAContext()
        
        guard isBiometryReady() else {return}
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Use sua impressão digital para acessar a conta.") {
                                (success, evaluateError) in
                                if success {
                                    DispatchQueue.main.async {
                                        completion("success")
                                    }
                                } else {
                                    let message: String
                                    
                                    switch evaluateError {
                                    case LAError.authenticationFailed?:
                                        message = "There was a problem verifying your identity."
                                    case LAError.userCancel?:
                                        message = "You pressed cancel."
                                    case LAError.userFallback?:
                                        completion("password")
                                        message = "You pressed password."
                                    default:
                                        message = "Touch ID may not be configured"
                                    }
                                    
                                    completion(message)
                                }
        }
    }
    
    func isBiometryReady() -> Bool{
        let context : LAContext = LAContext();
        var error : NSError?
        
        if (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error)){
            return true
        }
        
        if error?.code == -8 {
            let reason:String = "O Touch ID foi bloqueado. Digite a senha do iPhone para ativar esse recurso novamente.";
            
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in}
            return true
        }
        
        return false
    }
}
