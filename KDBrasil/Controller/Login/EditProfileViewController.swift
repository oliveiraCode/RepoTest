//
//  EditProfileViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-02.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth
import KRProgressHUD

class EditProfileViewController: UIViewController {
    
    
    //IBOutlets
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfWhatsApp: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPasswordConfirm: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
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
        
        self.tfFirstName.text = appDelegate.userObj.firstName
        self.tfLastName.text = appDelegate.userObj.lastName
        self.tfPhone.text = appDelegate.userObj.phone
        self.tfWhatsApp.text = appDelegate.userObj.whatsapp
        self.tfEmail.text = appDelegate.userObj.email
        self.imgProfile.image = appDelegate.userObj.image
        
        self.imgProfile.layer.cornerRadius = imgProfile.bounds.height / 2
        self.imgProfile.clipsToBounds = true
        
    }
    
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        
        if checkFields() {
            
            appDelegate.userObj.firstName = self.tfFirstName.text
            appDelegate.userObj.lastName = self.tfLastName.text
            appDelegate.userObj.phone = self.tfPhone.text
            appDelegate.userObj.whatsapp = self.tfWhatsApp.text
            appDelegate.userObj.email = self.tfEmail.text
            appDelegate.userObj.image = self.imgProfile.image
            
            
            KRProgressHUD.show(withMessage: NSLocalizedString(LocalizationKeys.pleaseWait, comment: "")) {
                //atualizar a image
                FIRFirestoreService.shared.saveImageToStorage()
                
                //atualizar o email
                if self.checkFieldPassword() {
                    Auth.auth().currentUser?.updatePassword(to: self.tfPassword.text!, completion: nil)
                }
                Auth.auth().currentUser?.updateEmail(to: self.tfEmail.text!, completion: nil)
                
                
                //atualizar o banco
                FIRFirestoreService.shared.saveProfileToFireStore()
                CoreDataService.shared.saveCurrentUserToCoreData()
                
                let alert = UIAlertController(title: "", message: LocalizationKeys.updateProfile, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: LocalizationKeys.buttonOK, style: .default, handler: { action in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
                KRProgressHUD.dismiss()
            }
            
        }
        
    }
    
    private func checkFieldPassword() -> Bool{
        guard tfPassword.text == tfPasswordConfirm.text else {
            self.showAlert(title: FirebaseAuthErrors.warning, message: CommonWarning.passwordDontMatch);
            return false
        }
        return true
    }
    
    private func checkFields() -> Bool{
        //Checks if the required fields are empty.
        guard tfFirstName.text != "" else {self.showAlert(errorCode: .invalidSender)
            return false}
        guard tfEmail.text != "" else {self.showAlert(errorCode: .invalidSender)
            return false}
        
        return true
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

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            appDelegate.userObj.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
