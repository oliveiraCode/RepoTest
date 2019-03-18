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

class LoginMainViewController: BaseViewController {
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.borderColor = UIColor.black.cgColor
        btnLogin.layer.borderWidth = 0.5
        btnLogin.layer.cornerRadius = 20
        btnLogin.layer.masksToBounds = true
        
        btnFacebook.layer.cornerRadius = 20
        btnFacebook.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnFacebookPressed(_ sender: UIButton) {
        
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
                self.appDelegate.userObj.isFacebook = true
                self.appDelegate.userObj.creationDate = Date.getFormattedDate(date: (result?.user.metadata.creationDate?.description)!, formatter: "dd/MM/yyyy HH:mm:ss")
                
                var imageFacebook = UIImageView()
                imageFacebook.kf.setImage(with: (result?.user.photoURL)!){
                    result in
                    switch result {
                    case .success(let value):
                        self.appDelegate.userObj.image = value.image
                        FIRFirestoreService.shared.saveImageToStorage()
                        FIRFirestoreService.shared.saveProfileToFireStore()
                        CoreDataService.shared.saveCurrentUserToCoreData()
                        
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
    
}
