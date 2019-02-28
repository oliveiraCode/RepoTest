//
//  LoginViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import Kingfisher

class LoginViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    //MARK - SetupUI
    func setupUI(){
        btnLogin?.layer.cornerRadius = 15
        btnLogin?.layer.masksToBounds = true
        
        btnFacebook?.layer.cornerRadius = 20
        btnFacebook?.layer.masksToBounds = true
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        
        guard let email = tfEmail.text else {return}
        guard let password = tfPassword.text else {return}
        
        //check if they have value
        guard email != "" else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailEmpty);
            return
        }
        guard password != ""  else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.passwordEmpty);
            return
        }
        
        self.activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(errorCode: errCode)
                }
            } else {
                FIRFirestoreService.shared.getDataFromCurrentUser(password:password,completionHandler: { (error) in
                    if error == nil {
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    @IBAction func btnLoginNotNow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        guard let email = tfEmail.text else {return}
        var accountFacebook:String?
        
        //check if they have value
        guard email != "" else {self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailResetPassword); return}
        
        //Show Activity Indicator
        self.activityIndicator.startAnimating()
        
        //check what the provider is
        Auth.auth().fetchProviders(forEmail: email) { (value, err) in
            
            if err == nil {
                accountFacebook = value?[0]
                if accountFacebook == "facebook.com" {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: "Conta Facebook", message: "O e-mail \(email) é de uma conta facebook. \n\nUse a opção facebook para se conectar.")
                } else {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: FirebaseAuthErrors.warning, message: FirebaseAuthErrors.userNotFound)
                }
            }
            
            if accountFacebook == "password" || accountFacebook == nil{
                Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                    if error == nil {
                        self.activityIndicator.stopAnimating()
                        self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.emailSentResetPassword)
                    } else {
                        if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                            self.activityIndicator.stopAnimating()
                            self.showAlert(errorCode: errCode)
                        }
                    }
                })
            }
        }
        
    }
    
    
    @IBAction func loginFacebookTapped(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile","email"], from: self){(result,error) in
            if error != nil{
                
            }else if result!.isCancelled{
                print("User cancelled login")
            }else{
                self.useFirebaseLogin()
            }
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
                self.appDelegate.userObj.isFacebook = true
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"
                
                self.appDelegate.userObj.creationDate = dateFormatterGet.string(from: (result?.user.metadata.creationDate)!)
                
                var imageFacebook = UIImageView()
                imageFacebook.kf.setImage(with: (result?.user.photoURL)!){
                    result in
                    switch result {
                    case .success(let value):
                        self.appDelegate.userObj.image = value.image
                        FIRFirestoreService.shared.saveImageToStorage()
                        FIRFirestoreService.shared.saveProfileToFireStore()
                        CoreDataService.shared.saveCurrentUserToCoreData()
                    case .failure(let error):
                        self.activityIndicator.stopAnimating()
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
                
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "", message: "Bem vindo \(self.appDelegate.userObj.firstName!)", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: { (nil) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            }else{
                self.activityIndicator.stopAnimating()
                self.showAlert(title: "Erro", message: "Não foi possível conectar usando os dados dessa conta, verifique o e-mail e tente novamente.")
                print("Could not Login user \(String(describing: error?.localizedDescription))")
            }
        }
        
    }
}
