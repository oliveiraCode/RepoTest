//
//  LoginMainViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import LocalAuthentication

class LoginMainViewController: BaseViewController {
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.masksToBounds = true
        btnFacebook.layer.cornerRadius = 5
        btnFacebook.layer.masksToBounds = true
        btnGoogle.layer.cornerRadius = 5
        btnGoogle.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnFacebookPressed(_ sender: UIButton) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self){(result,error) in
            
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let result = result else { return }
            if result.isCancelled { return }
        
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email"]).start() {
                (connection, result, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let fields = result as? [String:Any] {
                    
                    guard let email = fields["email"] as? String else {return}
                    
                    FIRFirestoreService.shared.checkIfUserExists(email: email, completionHandler: { (userExists) in
                        
                        if userExists {
                            self.useFirebaseLogin()
                            
                        } else {
                            let alert = UIAlertController(title: "Perfil de usuário", message: LocalizationKeys.typeOfUser, preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Cliente", style: .default, handler: { (action) in
                                self.appDelegate.userObj.userType = userType.client
                                self.useFirebaseLogin()
                            }))
                            
                            alert.addAction(UIAlertAction(title: "Profissional", style: .default, handler: { (action) in
                                self.appDelegate.userObj.userType = userType.professional
                                self.useFirebaseLogin()
                            }))
                            
                            self.present(alert, animated: true, completion: nil)

                        }
                    })
                    
                }
                
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (UIApplication.shared.delegate as! AppDelegate).userObj.id != nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func useFirebaseLogin(){
        //Show Activity Indicator
        self.activityIndicator.startAnimating()
        
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential){(result,error) in
            
            if error == nil{
                self.appDelegate.userObj.email = result?.user.email!
                
                let fullName = result?.user.displayName
                let fullNameArr = fullName!.components(separatedBy: " ")
                self.appDelegate.userObj.firstName = fullNameArr[0]
                self.appDelegate.userObj.lastName = fullNameArr[1]
                self.appDelegate.userObj.id = result?.user.uid
                self.appDelegate.userObj.phone = result?.user.phoneNumber ?? ""
                self.appDelegate.userObj.image = UIImage(named: "placeholder_photo")
                self.appDelegate.userObj.authenticationType = authenticationType.facebook
                
                
                self.appDelegate.userObj.creationDate = Date.getFormattedDate(date: (result?.user.metadata.creationDate?.description)!, formatter: "dd/MM/yyyy HH:mm:ss")
                var imageFacebook = UIImageView()
                imageFacebook.kf.setImage(with: (result?.user.photoURL)!){
                    result in
                    switch result {
                    case .success(let value):
                        self.appDelegate.userObj.image = value.image
                        
                        FIRFirestoreService.shared.saveData(completion: { (error) in
                            //
                        })
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        
                    case .failure(let error):
                        self.activityIndicator.stopAnimating()
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                
            }else{
                self.activityIndicator.stopAnimating()
                self.showAlert(title: "Erro", message: "Não foi possível conectar usando os dados dessa conta, verifique o e-mail e tente novamente.")
                print("Could not Login user \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
    
    @IBAction func btnLoginNotNow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if UserDefaults.standard.bool(forKey: "isTouchID") {
            
            TouchIDHandler.shared.authenticateUser { (result) in
                if result == "success" {
                    self.loginWithTouchID()
                }
                if result == "password" {
                    self.performSegue(withIdentifier: "showLoginVC", sender: nil)
                }
            }
        } else {
            performSegue(withIdentifier: "showLoginVC", sender: nil)
        }
        
    }
    
    private func loginWithTouchID(){
        let email = "fernandes.oliveira@outlook.com"
        let password = "123456"
        
        self.activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(errorCode: errCode)
                }
            } else {
                FIRFirestoreService.shared.getDataFromCurrentUser(completionHandler: { (error) in
                    if error == nil {
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
}
