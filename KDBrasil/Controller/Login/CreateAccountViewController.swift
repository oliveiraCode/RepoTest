//
//  CreateAccountViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos

class CreateAccountViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPasswordConfirm: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
 
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
        setupUI()
    }
    
    //MARK - SetupUI
    func setupUI(){
        btnCreateAccount?.layer.cornerRadius = 15
        btnCreateAccount?.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        
        //Checks if the required fields are empty.
        guard tfFirstName.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfEmail.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfPassword.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfPasswordConfirm.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        
        guard tfPassword.text == tfPasswordConfirm.text else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.passwordDontMatch);
            return
        }
        
        self.activityIndicator.startAnimating()
        //check what the provider is
        Auth.auth().fetchProviders(forEmail: tfEmail.text!) { (value, err) in
            if err == nil {
                guard let accountFacebook = value?[0] else {return}
                if accountFacebook == "facebook.com" {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: "Conta Facebook", message: "A conta \(self.tfEmail.text!) já existe e é uma conta facebook. \n\nUse a opção facebook para se conectar.")
                } else {
                    
                    
                        
                        //set all information to user object
                        self.appDelegate.userObj.firstName = self.tfFirstName.text
                        self.appDelegate.userObj.lastName = self.tfLastName.text
                        self.appDelegate.userObj.email = self.tfEmail.text
                        self.appDelegate.userObj.password = self.tfPassword.text
                        self.appDelegate.userObj.image = self.profileImageView.image
                        self.appDelegate.userObj.creationDate = Service.shared.getTodaysDate()
                        self.appDelegate.userObj.isFacebook = false
                        
                        FIRFirestoreService.shared.createUser { (error) in
                            if error != nil {
                                if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                                    self.activityIndicator.stopAnimating()
                                    self.showAlert(errorCode: errCode)
                                }
                            } else {
                                let alert = UIAlertController(title: General.congratulations, message: General.successfully, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: { (action) in
                                    self.performSegue(withIdentifier: "unWindToMenuVC", sender: nil)
                                }))
                                self.activityIndicator.stopAnimating()
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    
                }
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnChangeImage(_ sender: Any) {
        
        Service.shared.checkPermissionPhotoLibrary { (status) in
            if status == .authorized {
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCamera, style: .default, handler: { action in
                    let cameraPicker = UIImagePickerController()
                    cameraPicker.delegate = self
                    cameraPicker.sourceType = .camera
                    cameraPicker.allowsEditing = true
                    self.present(cameraPicker, animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: LocalizationKeys.buttonPhotoLibrary, style: .default, handler: { action in
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = true
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCancel, style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                
                let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: 250,height: 10)
                
                let alert = UIAlertController(title: General.warning, message: General.warningPhotoCameraDenied, preferredStyle: .alert)
                alert.setValue(vc, forKey: "contentViewController")
                
                alert.addAction(UIAlertAction(title: General.OK, style: .cancel, handler: nil))
                self.present(alert, animated: true)
                
            }
        }
    }
}

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
