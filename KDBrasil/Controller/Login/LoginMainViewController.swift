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

class LoginMainViewController: UIViewController {

    
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

        if Auth.auth().currentUser?.uid != nil {
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
 
    @IBAction func btnLoginNotNow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
