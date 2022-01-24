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

class CreateAccountViewController: BaseViewController {
    
    //IBOutlets
    @IBOutlet weak var segmentedControlUserType: UISegmentedControl!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfFirstName.becomeFirstResponder()
    }
    
    //MARK - SetupUI
    func setupUI(){
        
        btnCreateAccount.layer.cornerRadius = 5
        btnCreateAccount.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        
        if segmentedControlUserType.selectedSegmentIndex != 0 && segmentedControlUserType.selectedSegmentIndex != 1 {
            self.showAlert(title: "Atenção!", message: "É necessário escolher o tipo de usuário: Cliente ou Profissional")
            return
        }
        //Checks if the required fields are empty.
        guard tfFirstName.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfEmail.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}
        guard tfPassword.text != "" else {self.showAlert(errorCode: .invalidSender)
            return}

        
        //set all information to user object
        self.appDelegate.userObj.firstName = self.tfFirstName.text
        self.appDelegate.userObj.email = self.tfEmail.text
        self.appDelegate.userObj.password = self.tfPassword.text
        self.appDelegate.userObj.image = self.profileImageView.image
        self.appDelegate.userObj.creationDate = Date.getFormattedDate(date: Date().description, formatter: "dd/MM/yyyy HH:mm:ss")
        self.appDelegate.userObj.authenticationType = authenticationType.email
       
        if segmentedControlUserType.selectedSegmentIndex == 0 {
            self.appDelegate.userObj.userType = userType.client
        } else {
            self.appDelegate.userObj.userType = userType.professional
        }
        
        FIRFirestoreService.shared.createUser { (error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: (error?._code)!) {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(errorCode: errCode)
                }
            } else {
                let alert = UIAlertController(title: General.congratulations, message: General.successfully, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.activityIndicator.stopAnimating()
                self.present(alert, animated: true, completion: nil)
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
