//
//  MyBusinessViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import PhoneNumberKit

class MyBusinessViewController: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate  {
    
    //IBOutlets
    @IBOutlet weak var lbCountryCodePhone: UILabel!
    @IBOutlet weak var lbCountryCodeWhatsApp: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfStreet: UITextField!
    @IBOutlet weak var tfComplement: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfCEP: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfWhatsapp: UITextField!
    @IBOutlet weak var tfWeb: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Properties
    var businessDetails = Business()
    var isNewBusiness:Bool?
    var activityIndicator = UIActivityIndicatorView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var categoryValue:String?
    var photosValue:[UIImage]?
    var indexPathItemForImage:Int?
    let dateFormatter = DateFormatter()
    var imageArrayForStorage:[UIImage] = [UIImage(named: "placeholder_photo_new_ad")!]
    
    let pickerView = ToolbarPickerView()
    var stateFull:[String] = []
    var stateAlphaCode:[String] = []
    
    func setStates(){
        for (_,value) in (appDelegate.currentCountry?.allStates?.geonames.enumerated())!{
            stateFull.append(value.name!)
            stateAlphaCode.append((value.adminCodes1?.ISO3166_2)!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStates()
        self.dateFormatter.dateFormat = "HH:mm"
        
        self.tfState.inputView = self.pickerView
        self.tfState.inputAccessoryView = self.pickerView.toolbar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.reloadAllComponents()
        
        self.hideKeyboardWhenTappedAround()
        
        self.setLayoutUITextView()
        
        if isNewBusiness! {
            self.title = "Novo Anúncio"
        } else {
            self.title = "Editar Anúncio"
            self.startActivityIndicator()
            self.updateUI()
        }
        
        lbCountryCodePhone.text = appDelegate.currentCountry?.dial_code
        lbCountryCodeWhatsApp.text = appDelegate.currentCountry?.dial_code
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if categoryValue != nil {
            btnCategory.setTitle(self.categoryValue, for: .normal)
        }
        
        if photosValue != nil{
            self.imageArrayForStorage = photosValue!
            self.collectionViewPhoto.reloadData()
        }

    }
    
    
    //MARK: - Activity Indicator
    func startActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor.black
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func updateUI(){
        tfName.text = businessDetails.name
        tvDescription.text = businessDetails.description
        tvDescription.textColor = UIColor.black
        btnCategory.setTitle(businessDetails.category, for: .normal)
        tfNumber.text = businessDetails.address?.number
        tfStreet.text = businessDetails.address?.street
        tfComplement.text = businessDetails.address?.complement
        tfCity.text = businessDetails.address?.city
        tfState.text = businessDetails.address?.province
        tfCEP.text = businessDetails.address?.postalCode
        tfEmail.text = businessDetails.contact?.email
        tfPhone.text = businessDetails.contact?.phone
        tfWhatsapp.text = businessDetails.contact?.whatsapp
        tfWeb.text = businessDetails.contact?.web
        
        tfPhone.text = String((tfPhone.text?.dropFirst(3))!)
        tfWhatsapp.text = String((tfWhatsapp.text?.dropFirst(3))!)
        

        if let countImage = self.businessDetails.photosURL?.count {
            
            for index in 0...countImage-1 {
                
                let image = UIImageView()
                image.kf.setImage(with: URL(string: self.businessDetails.photosURL![index])){
                    result in
                    switch result {
                    case .success(let value):
                        self.imageArrayForStorage.insert(value.image, at: index)
                        self.collectionViewPhoto.reloadData()
                    case .failure(let error):
                        print("Job failed: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        
        self.activityIndicator.stopAnimating()
    }
    
    @IBAction func cancelPressed (_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func categoryPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showCategoryVC", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showCategoryVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! CategoryViewController
            destController.delegate = self
        }
        
        
        if segue.identifier == "showPhotosVC" {
            let destController = segue.destination as! PhotosViewController
            destController.arrayPhotos = imageArrayForStorage
            destController.delegate = self
        }
        
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        if isFieldsWithValues() {
            
            guard let description = tvDescription.text else {return}
            guard let name = tfName.text else {return}
            
            guard let number = tfNumber.text else {return}
            guard let street = tfStreet.text else {return}
            guard let complement = tfComplement.text else {return}
            guard let city = tfCity.text else {return}
            guard let province = tfState.text else {return}
            guard let postalCode = tfCEP.text else {return}
            
            guard let email = tfEmail.text else {return}
            guard var phone = tfPhone.text else {return}
            guard var whatsapp = tfWhatsapp.text else {return}
            guard let web = tfWeb.text else {return}
            guard let category = btnCategory.title(for: .normal) else {return}
            guard let country = appDelegate.currentCountry?.name else {return}
            
            if !phone.isEmpty {
                phone = "\(lbCountryCodePhone.text!) \(phone)"
            }
            if !whatsapp.isEmpty {
                whatsapp = "\(lbCountryCodeWhatsApp.text!) \(whatsapp)"
            }
            
            self.activityIndicator.startAnimating()
            let creationDate:String
            if isNewBusiness! {
                creationDate = Date.getFormattedDate(date: Date().description, formatter: "dd/MM/yyyy HH:mm:ss +zzzz")
            } else {
                creationDate = Date.getFormattedDate(date: self.businessDetails.creationDate!, formatter: "dd/MM/yyyy HH:mm:ss +zzzz")
                
            }
            
            Service.shared.getCoordinateFromGeoCoder(address: "\(number) \(street), \(city), \(province) \(postalCode)") { (coordinate, error) in
                
                if error == nil {
                    let contact:Contact = Contact(email: email, phone: phone,whatsapp: whatsapp, web: web)
                    
                    let address:Address = Address(number: number, street: street, complement: complement, city: city, province: province,country: country, postalCode: postalCode, latitude: coordinate!.coordinate.latitude, longitude: coordinate!.coordinate.longitude)
                    
                    let business = Business(id:"", description: description, name: name,rating: 0.0, address: address, contact: contact, creationDate: creationDate, category: category, user_id: (UIApplication.shared.delegate as! AppDelegate).userObj.id, photosURL:[""],country:country)
                    
                    if !(self.isNewBusiness!) {
                        FIRFirestoreService.shared.removeData(business: self.businessDetails)
                    }
                    
                    self.imageArrayForStorage.removeLast()
                    FIRFirestoreService.shared.saveData(business: business, imageArray: self.imageArrayForStorage)
     
                    var messageBusiness:String
                    if self.isNewBusiness! {
                        messageBusiness = General.businessCreated
                    } else {
                        messageBusiness = General.businessEdited
                    }
                    self.activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: "", message: messageBusiness, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: { (nil) in
                        
                        if self.isNewBusiness! {
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            self.performSegue(withIdentifier: "unWindSegueToBusinessesTableVC", sender: nil)
                        }
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                } else {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: General.warning, message: "Não foi possível validar o seu endereço. \n\n Por favor, verifique-o e tente novamente.")
                    print("error \(error!.localizedDescription)")
                }
            }
            
        }
    }
    
    
    
    //MARK -> PickImage's method
    @objc func pickImage(_ sender:AnyObject) {
        performSegue(withIdentifier: "showPhotosVC", sender: nil)
    }
    
    //MARK -> CollectionView's methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArrayForStorage.count //return value for CollectionViewPhoto
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellPhoto = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionPhotoCell", for: indexPath) as! PhotoCollectionViewCell
        
        cellPhoto.imageCellBusiness.image = imageArrayForStorage[indexPath.item]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.pickImage(_:)))
        cellPhoto.imageCellBusiness.isUserInteractionEnabled = true
        cellPhoto.imageCellBusiness.tag = indexPath.row
        cellPhoto.imageCellBusiness.addGestureRecognizer(tapGestureRecognizer)
        
        return cellPhoto
        
    }
    
    //MARK - UITextView setup
    func setLayoutUITextView(){
        tvDescription.delegate = self
        tvDescription.text = Placeholders.placeholder_descricao
        tvDescription.textColor = UIColor.lightGray
        
        //to make a border on TextView
        tvDescription.layer.borderWidth = 0.3
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvDescription.textColor == UIColor.lightGray {
            tvDescription.text = nil
            tvDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvDescription.text.isEmpty {
            tvDescription.text = Placeholders.placeholder_descricao
            tvDescription.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            if appDelegate.userObj.email != nil && !appDelegate.userObj.email.isEmpty  {
                tfEmail.text = appDelegate.userObj.email
            }
            if appDelegate.userObj.phone != nil && !appDelegate.userObj.phone!.isEmpty {
                tfPhone.text = String(appDelegate.userObj.phone!.dropFirst(3))
            }
            if appDelegate.userObj.whatsapp != nil && !appDelegate.userObj.whatsapp!.isEmpty  {
                tfWhatsapp.text = String(appDelegate.userObj.whatsapp!.dropFirst(3))
            }
            
        } else {
            tfEmail.text = ""
            tfPhone.text = ""
            tfWhatsapp.text = ""
        }
        
    }
    
    func isFieldsWithValues() -> Bool{
        
        guard self.imageArrayForStorage.count > 1 else {self.showAlert(title: General.warning, message: "É necessário escolher pelo menos 1 imagem.");return false}
        
        guard self.tfName.text != "" else {self.showAlert(title: General.warning, message: "O nome do título deve ser preenchido");return false}
        
        guard self.tvDescription.text != "Escreva aqui a descrição do seu anúncio." else { self.showAlert(title: General.warning, message: "O campo descrição deve ser preenchido"); return false}
        
        guard self.btnCategory.titleLabel?.text != "Selecionar" else { self.showAlert(title: General.warning, message: "A categoria deve ser selecionada."); return false}
        
        guard self.tfCity.text != "" else { self.showAlert(title: General.warning, message: "O campo cidade deve ser preenchido"); return false}
        
        guard self.tfState.text != "" else { self.showAlert(title: General.warning, message: "O campo estado deve ser preenchido"); return false}
        
        guard self.tfCEP.text != "" else { self.showAlert(title: General.warning, message: "O campo CEP deve ser preenchido"); return false}
        
        guard self.tfEmail.text != "" else { self.showAlert(title: General.warning, message: "O campo e-mail deve ser preenchido"); return false}
        
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == tfWeb {
            
            if (textField.text?.lowercased().contains("https://"))! {
                textField.text = String((textField.text?.dropFirst(8))!)
            } else if (textField.text?.lowercased().contains("http://"))! {
                textField.text = String((textField.text?.dropFirst(7))!)
            }
            if !(textField.text?.lowercased().contains("www"))! {
                textField.text = "www.\(textField.text!)"
            }
            
            
            if let last = textField.text?.last, last == "/" {
                textField.text = String((textField.text?.dropLast())!)
            }
            textField.text = textField.text?.lowercased()
            
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let pnTextField = PhoneNumberTextField()
        pnTextField.defaultRegion = (appDelegate.currentCountry?.code)!
        pnTextField.text = textField.text
        
        
        //MARK:- If Delete button click
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
    
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            textField.text!.removeLast()
            return false
        }
        
        if textField == tfPhone {
            if (textField.text?.count)! <= 13 {
                textField.text =  pnTextField.text
            } else {
                return false
            }
        }
        
        if textField == tfWhatsapp {
            if (textField.text?.count)! <= 13 {
                textField.text =  pnTextField.text
            } else {
                return false
            }
        }
        return true
        
    }
    
}


//MARK: Category Delegate
extension MyBusinessViewController: CategoryDelegate {
    func categoryValueSelected(categoryValue: String) {
        self.categoryValue = categoryValue
    }
}

//MARK: Photos Delegate
extension MyBusinessViewController: PhotosDelegate {
    func photosValueSelected(photosValue: [UIImage]) {
        self.photosValue = photosValue
    }
}

//MARK: PickerView
extension MyBusinessViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.stateFull.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.stateFull[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.stateAlphaCode[row].isNumeric {
            self.tfState.text = self.stateFull[row]
        } else {
            self.tfState.text = self.stateAlphaCode[row]
        }
    }
}

extension MyBusinessViewController: ToolbarPickerViewDelegate {
    
    func didTapSave() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        if self.stateAlphaCode[row].isNumeric {
            self.tfState.text = self.stateFull[row]
        } else {
            self.tfState.text = self.stateAlphaCode[row]
        }
        self.tfState.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.tfState.text = nil
        self.tfState.resignFirstResponder()
    }
}


extension MyBusinessViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        if imageArrayForStorage.count == 1 {
            return UIEdgeInsets(top: 0.0, left: (UIScreen.main.bounds.width - 120.0)/2, bottom: 0.0, right: (UIScreen.main.bounds.width - 120.0)/2)
        }
        
        return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10.0
    }
    
}
