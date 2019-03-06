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

class MyBusinessViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate  {
    
    //IBOutlets
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
    @IBOutlet weak var pageControlPhoto: UIPageControl!
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    @IBOutlet weak var btnMonday: UIButton!
    @IBOutlet weak var btnTuesday: UIButton!
    @IBOutlet weak var btnWednesday: UIButton!
    @IBOutlet weak var btnThursday: UIButton!
    @IBOutlet weak var btnFriday: UIButton!
    @IBOutlet weak var btnSaturday: UIButton!
    @IBOutlet weak var btnSunday: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Properties
    var customView:WeekHour!
    var businessDetails = Business()
    var isNewBusiness:Bool?
    var dailyHoursArray = [DailyHours]()
    var btnWeekArray:[UIButton?] = []
    var indexWeek:Int?
    var activityIndicator = UIActivityIndicatorView()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var categoryValue:String?
    var indexPathItemForImage:Int?
    var countThreePhotos = 0 //default value
    let dateFormatter = DateFormatter()
    var imageArrayForStorage:[UIImage] = [UIImage(named: "placeholder_photo_new_ad")!,
                                          UIImage(named: "placeholder_photo_new_ad")!,
                                          UIImage(named: "placeholder_photo_new_ad")!]
    let weekArray:[String] = [ NSLocalizedString(LocalizationKeys.monday, comment: ""),
                               NSLocalizedString(LocalizationKeys.tuesday, comment: ""),
                               NSLocalizedString(LocalizationKeys.wednesday, comment: ""),
                               NSLocalizedString(LocalizationKeys.thursday, comment: ""),
                               NSLocalizedString(LocalizationKeys.friday, comment: ""),
                               NSLocalizedString(LocalizationKeys.saturday, comment: ""),
                               NSLocalizedString(LocalizationKeys.sunday, comment: "")
    ]
    
    let pickerView = ToolbarPickerView()
    let stateFull = State.stateFull
    let stateAlphaCode =  State.stateAlphaCode
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter.dateFormat = "HH:mm"
        
        self.tfState.inputView = self.pickerView
        self.tfState.inputAccessoryView = self.pickerView.toolbar
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.toolbarDelegate = self
        self.pickerView.reloadAllComponents()
        
        
        btnWeekArray.append(btnMonday)
        btnWeekArray.append(btnTuesday)
        btnWeekArray.append(btnWednesday)
        btnWeekArray.append(btnThursday)
        btnWeekArray.append(btnFriday)
        btnWeekArray.append(btnSaturday)
        btnWeekArray.append(btnSunday)
        
        for index in 0...6 {
            dailyHoursArray.append(DailyHours(is_overnight: false, is_closed: false, start: "-", end: "-", day: index))
        }
        self.hideKeyboardWhenTappedAround()
        
        self.setLayoutUITextView()
        
        if isNewBusiness! {
            self.title = "Novo Anúncio"
        } else {
            self.title = "Editar Anúncio"
            self.countThreePhotos = 3
            self.startActivityIndicator()
            self.updateUI()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if categoryValue != nil {
            btnCategory.setTitle(self.categoryValue, for: .normal)
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
        
        self.imageArrayForStorage.removeAll()
        
        for index in 0...2 {
            
            let image = UIImageView()
            image.kf.setImage(with: URL(string: self.businessDetails.photosURL![index])){
                result in
                switch result {
                case .success(let value):
                    self.imageArrayForStorage.append(value.image)
                    self.collectionViewPhoto.reloadData()
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
            
        }
        
        //put all week days in correct order
        businessDetails.hours = businessDetails.hours?.sorted(by: { $0.day! < $1.day! })
        dailyHoursArray = businessDetails.hours!
        
        for (indexWeek, _) in btnWeekArray.enumerated() {
            if businessDetails.hours![indexWeek].is_closed! {
                let title = "Fechado"
                btnWeekArray[indexWeek]?.setTitle(title, for: .normal)
                btnWeekArray[indexWeek]?.setTitleColor(UIColor.red, for: .normal)
            } else
                
                if businessDetails.hours![indexWeek].is_overnight! {
                    let title = "24 horas"
                    btnWeekArray[indexWeek]?.setTitle(title, for: .normal)
                    btnWeekArray[indexWeek]?.setTitleColor(UIColor.black, for: .normal)
                } else {
                    let title = "\(businessDetails.hours![indexWeek].start!) - \(businessDetails.hours![indexWeek].end!)"
                    btnWeekArray[indexWeek]?.setTitle(title, for: .normal)
                    btnWeekArray[indexWeek]?.setTitleColor(UIColor.black, for: .normal)
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
            let destController = navController.topViewController as! CategoryTableViewController
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
            guard let phone = tfPhone.text else {return}
            guard let whatsapp = tfWhatsapp.text else {return}
            guard let web = tfWeb.text else {return}
            guard let category = btnCategory.title(for: .normal) else {return}
            
            self.activityIndicator.startAnimating()
            let creationDate:String
            if isNewBusiness! {
                creationDate = Service.shared.getTodaysDate()
            } else {
                creationDate = self.businessDetails.creationDate!
            }
            
            Service.shared.getCoordinateFromGeoCoder(address: "\(number) \(street), \(city), \(province) \(postalCode)") { (coordinate, error) in
                
                if error == nil {
                    let contact:Contact = Contact(email: email, phone: phone,whatsapp: whatsapp, web: web)
                    
                    let address:Address = Address(number: number, street: street, complement: complement, city: city, province: province, postalCode: postalCode, latitude: coordinate!.coordinate.latitude, longitude: coordinate!.coordinate.longitude)
                    
                    let business = Business(id:"", description: description, name: name,rating: 0.0, address: address, contact: contact, creationDate: creationDate, category: category, user_id: (UIApplication.shared.delegate as! AppDelegate).userObj.id, hours:self.dailyHoursArray, photosURL:["","",""])
                    
                    if !(self.isNewBusiness!) {
                        FIRFirestoreService.shared.removeData(business: self.businessDetails)
                    }
                    
                    FIRFirestoreService.shared.saveData(business: business, imageArray: self.imageArrayForStorage)
                    
                     self.activityIndicator.stopAnimating()
                    let alert = UIAlertController(title: General.congratulations, message: General.businessCreated, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: { (nil) in
                        self.dismiss(animated: true, completion: nil)
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
        
        indexPathItemForImage = sender.view.tag //to know witch item was selected.
        
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControlPhoto.currentPage = indexPath.item
    }
    
    //MARK - UITextView setup
    func setLayoutUITextView(){
        tvDescription.delegate = self
        tvDescription.text = Placeholders.placeholder_descricao
        tvDescription.textColor = UIColor.lightGray
        
        //to make a border on TextView
        tvDescription.layer.borderWidth = 0.3
        tvDescription.layer.borderColor = UIColor.gray.cgColor
   
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
                tfEmail.isEnabled = false
                tfEmail.text = appDelegate.userObj.email
            }
            if appDelegate.userObj.phone != nil && !appDelegate.userObj.phone!.isEmpty {
                tfPhone.isEnabled = false
                tfPhone.text = appDelegate.userObj.phone
            }
            if appDelegate.userObj.whatsapp != nil && !appDelegate.userObj.whatsapp!.isEmpty  {
                tfWhatsapp.isEnabled = false
                tfWhatsapp.text = appDelegate.userObj.whatsapp
            }
            
        } else {
            tfEmail.isEnabled = true
            tfPhone.isEnabled = true
            tfWhatsapp.isEnabled = true
            tfEmail.text = ""
            tfPhone.text = ""
            tfWhatsapp.text = ""
        }
        
    }
    
    @IBAction func btnWeekHourPressed(_ sender: UIButton) {
        indexWeek = sender.tag
        self.tfState.resignFirstResponder()
        
        if customView != nil {
            customView.removeFromSuperview()
        }
        
        let height = 290
        customView = WeekHour(frame: CGRect.init(x: 0, y: Int(self.view.frame.height)-height, width:Int(self.view.bounds.width), height: height))
        
        self.view.addSubview(self.customView)
        self.customView.weekHourDelegate = self
        
        
        customView.lbWeek.text = self.weekArray[indexWeek!]
        
        if self.dailyHoursArray[indexWeek!].start != "-" && self.dailyHoursArray[indexWeek!].end != "-"{
            let dateStart = dateFormatter.date(from:self.dailyHoursArray[indexWeek!].start!)
            let dateEnd = dateFormatter.date(from:self.dailyHoursArray[indexWeek!].end!)
            
            customView.datePickerOpen.setDate(dateStart!, animated: false)
            customView.datePickerClose.setDate(dateEnd!, animated: false)
        }
        
        customView.switchClosed.isOn = self.dailyHoursArray[indexWeek!].is_closed!
        customView.switch24Hours.isOn = self.dailyHoursArray[indexWeek!].is_overnight!
        
    }
    
    func isFieldsWithValues() -> Bool{
        
        guard self.countThreePhotos >= 3 else { self.showAlert(title: General.warning, message: "São necessárias 3 imagens por anúncio"); return false}
        
        
        guard self.tfName.text != "" else {self.showAlert(title: General.warning, message: "O nome do título deve ser preenchido");return false}
        
        guard self.tvDescription.text != "Escreva aqui a descrição do seu anúncio." else { self.showAlert(title: General.warning, message: "O campo descrição deve ser preenchido"); return false}
        
        guard self.btnCategory.titleLabel?.text != "Selecionar" else { self.showAlert(title: General.warning, message: "A categoria deve ser selecionada."); return false}
        
        guard self.tfCity.text != "" else { self.showAlert(title: General.warning, message: "O campo cidade deve ser preenchido"); return false}
        
        guard self.tfState.text != "" else { self.showAlert(title: General.warning, message: "O campo estado deve ser preenchido"); return false}
        
        guard self.tfCEP.text != "" else { self.showAlert(title: General.warning, message: "O campo CEP deve ser preenchido"); return false}
        
        guard self.tfEmail.text != "" else { self.showAlert(title: General.warning, message: "O campo e-mail deve ser preenchido"); return false}
        
        return true
    }
    
    func dailyHoursValueSelected(dailyHoursValue: DailyHours) {
        self.dailyHoursArray.remove(at: indexWeek!)
        self.dailyHoursArray.insert(dailyHoursValue, at: indexWeek!)
    }
    
}


//MARK: Category Delegate
extension MyBusinessViewController: CategoryDelegate {
    func categoryValueSelected(categoryValue: String) {
        self.categoryValue = categoryValue
    }
}

//MARK: PickerImage
extension MyBusinessViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            if isNewBusiness! {
                if self.countThreePhotos == 0 {
                    self.countThreePhotos = 1
                } else {
                    self.countThreePhotos = self.countThreePhotos + 1
                }
            }
            
            imageArrayForStorage.remove(at: indexPathItemForImage!)
            imageArrayForStorage.insert(pickedImage, at: indexPathItemForImage!)
        }
        picker.dismiss(animated: true, completion: {self.collectionViewPhoto.reloadData()})
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
        self.tfState.text = self.stateAlphaCode[row]
    }
}

extension MyBusinessViewController: ToolbarPickerViewDelegate {
    
    func didTapSave() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.tfState.text = self.stateAlphaCode[row]
        self.tfState.resignFirstResponder()
    }
    
    func didTapCancel() {
        self.tfState.text = nil
        self.tfState.resignFirstResponder()
    }
}

//MARK: WeekHourDelegate
extension MyBusinessViewController: WeekHourDelegate {
    func btnSave(sender: UIBarButtonItem) {
        
        if self.dailyHoursArray[indexWeek!].is_closed! {
            self.dailyHoursArray[indexWeek!].start = "00:00"
            self.dailyHoursArray[indexWeek!].end = "00:00"
        }
        
        self.dailyHoursValueSelected(dailyHoursValue: self.dailyHoursArray[indexWeek!])
        
        if self.dailyHoursArray[indexWeek!].is_closed! {
            let title = "Fechado"
            btnWeekArray[indexWeek!]?.setTitle(title, for: .normal)
            btnWeekArray[indexWeek!]?.setTitleColor(UIColor.red, for: .normal)
        } else
            
            if self.dailyHoursArray[indexWeek!].is_overnight! {
                let title = "24 horas"
                btnWeekArray[indexWeek!]?.setTitle(title, for: .normal)
                btnWeekArray[indexWeek!]?.setTitleColor(UIColor.black, for: .normal)
            } else {
                let title = "\(self.dailyHoursArray[indexWeek!].start!) - \(self.dailyHoursArray[indexWeek!].end!)"
                btnWeekArray[indexWeek!]?.setTitle(title, for: .normal)
                btnWeekArray[indexWeek!]?.setTitleColor(UIColor.black, for: .normal)
        }
        
        dismissCustomView()
        
    }
    
    private func getHourFormatted(_ picker: UIDatePicker) -> String{
        picker.datePickerMode = .time
        
        return dateFormatter.string(from: picker.date)
    }
    
    func switch24HoursChanged(sender: UISwitch) {
        if customView.switchClosed.isOn {
            customView.switchClosed.isOn = !(sender.isOn)
        }
        
        customView.btnSave.isEnabled = sender.isOn
        self.dailyHoursArray[indexWeek!].is_overnight = customView.switch24Hours.isOn
        self.dailyHoursArray[indexWeek!].is_closed = customView.switchClosed.isOn
    }
    
    func switchClosedChanged(sender: UISwitch) {
        
        if customView.switch24Hours.isOn {
            customView.switch24Hours.isOn = !(sender.isOn)
        }
        customView.btnSave.isEnabled = sender.isOn
        self.dailyHoursArray[indexWeek!].is_overnight = customView.switch24Hours.isOn
        self.dailyHoursArray[indexWeek!].is_closed = customView.switchClosed.isOn
    }
    
    func datePickerOpen(sender: UIDatePicker) {
        customView.switch24Hours.isOn = false
        customView.switchClosed.isOn = false
        self.dailyHoursArray[indexWeek!].is_overnight = customView.switch24Hours.isOn
        self.dailyHoursArray[indexWeek!].is_closed = customView.switchClosed.isOn
        
        
        self.dailyHoursArray[indexWeek!].start = getHourFormatted(sender)
        
        if self.dailyHoursArray[indexWeek!].start != "00:00" && self.dailyHoursArray[indexWeek!].end != "00:00"{
            customView.btnSave.isEnabled = true
        }
    }
    
    func datePickerClose(sender: UIDatePicker) {
        customView.switch24Hours.isOn = false
        customView.switchClosed.isOn = false
        self.dailyHoursArray[indexWeek!].is_overnight = customView.switch24Hours.isOn
        self.dailyHoursArray[indexWeek!].is_closed = customView.switchClosed.isOn
        
        self.dailyHoursArray[indexWeek!].end = getHourFormatted(sender)
        
        if self.dailyHoursArray[indexWeek!].start != "00:00" && self.dailyHoursArray[indexWeek!].end != "00:00"{
            customView.btnSave.isEnabled = true
        }
    }
    
    func dismissCustomView(){
        
        if customView.isKind(of: WeekHour.self){
            UIView.animate(withDuration: 0.40, delay: 0, options: .curveEaseOut, animations: {
                self.customView.alpha = 0
            }) { _ in
                self.customView.removeFromSuperview()
            }
        }
    }
    
    func btnCancel(sender: UIBarButtonItem) {
        dismissCustomView()
    }
    
}

extension MyBusinessViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0.0, left: (UIScreen.main.bounds.width - 330.0)/2, bottom: 0.0, right: (UIScreen.main.bounds.width - 330.0)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return ((UIScreen.main.bounds.width - 330.0)/2)*2
    }
    
}
