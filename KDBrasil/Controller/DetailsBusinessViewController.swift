//
//  DetailsBusinessViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos
import MapKit
import CoreLocation
import KRProgressHUD

class DetailsBusinessViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,MKMapViewDelegate {
    
    //IBOutlets
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var cvRating: CosmosView!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnPhone: UIButton!
    @IBOutlet weak var btnWeb: UIButton!
    @IBOutlet weak var btnWhatsApp: UIButton!
    @IBOutlet weak var btnReviews: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var userNameAndMember: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lbMonday: UILabel!
    @IBOutlet weak var lbTuesday: UILabel!
    @IBOutlet weak var lbWednesday: UILabel!
    @IBOutlet weak var lbThursday: UILabel!
    @IBOutlet weak var lbFriday: UILabel!
    @IBOutlet weak var lbSaturday: UILabel!
    @IBOutlet weak var lbSunday: UILabel!
    @IBOutlet weak var lbOpenedClosed1: UILabel!
    @IBOutlet weak var lbOpenedClosed2: UILabel!
    
    //Properties
    var businessDetails = Business()
    var lbWeekArray:[UILabel?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbWeekArray.append(lbMonday)
        lbWeekArray.append(lbTuesday)
        lbWeekArray.append(lbWednesday)
        lbWeekArray.append(lbThursday)
        lbWeekArray.append(lbFriday)
        lbWeekArray.append(lbSaturday)
        lbWeekArray.append(lbSunday)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setValuesToUI()
        self.setAnnotationsOnTheMap()

        
        //set border to TextView
        tvDescription.layer.borderWidth = 0.6
        tvDescription.layer.borderColor = UIColor.gray.cgColor
        
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
        
        cvRating.settings.fillMode = .half
        
        FIRFirestoreService.shared.readAllReviewsFromBusiness(business: businessDetails) { (review, error) in
            if error == nil {
                self.businessDetails.reviews = review

                if self.businessDetails.reviews!.count == 0 || self.businessDetails.reviews!.count == 1 {
                    self.btnReviews.setTitle("(\(self.businessDetails.reviews!.count)) avaliação", for: .normal)
                } else {
                    self.btnReviews.setTitle("(\(self.businessDetails.reviews!.count)) avaliações", for: .normal)
                }
            }
        }
        
    }
    

    
    
    //MARK - Set values to UI
    func setValuesToUI(){
        
        FIRFirestoreService.shared.getDataFromUserBusiness(idUser: businessDetails.user_id!) { (user, error) in
            if error == nil {
                
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd/MM/yyyy"
                
                let creationDate = dateFormatterGet.date(from: "\(user!.creationDate!)")
             
                self.userNameAndMember.text = "\(user!.firstName!) é membro desde \(dateFormatterPrint.string(from: creationDate!))"
                self.userImage.image = user?.image
                
            }
        }
        
        for (_, dayOfWeek) in (businessDetails.hours?.enumerated())!{
            
            if dayOfWeek.is_closed! {
                lbWeekArray[dayOfWeek.day!]?.text = "Fechado"
                lbWeekArray[dayOfWeek.day!]?.textColor = UIColor.red
            } else if dayOfWeek.is_overnight! {
                lbWeekArray[dayOfWeek.day!]?.text = "24 horas"
                lbWeekArray[dayOfWeek.day!]?.textColor = UIColor.black
            } else {
                lbWeekArray[dayOfWeek.day!]?.text = dayOfWeek.start! + " - " + dayOfWeek.end!
                lbWeekArray[dayOfWeek.day!]?.textColor = UIColor.black
            }
            
        }
        
        let dateFormatter = DateFormatter()
        let weekFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        weekFormatter.dateFormat = "EEEE"
        weekFormatter.locale = Locale(identifier: "pt_BR")
        
        let currentHour = dateFormatter.string(from: Date())
        let currentDayOfWeek = weekFormatter.string(from: Date())
        
        let dayCode:Int?
        switch currentDayOfWeek {
        case "segunda-feira":
            dayCode = 0
        case "terça-feira":
            dayCode = 1
        case "quarta-feira":
            dayCode = 2
        case "quinta-feira":
            dayCode = 3
        case "sexta-feira":
            dayCode = 4
        case "sábado":
            dayCode = 5
        default:
            dayCode = 6
        }
        
        for (_, dayOfWeek) in (businessDetails.hours?.enumerated())!{
            if dayOfWeek.day == dayCode {
                
                
                if dayOfWeek.is_overnight! || (currentHour >= dayOfWeek.start! && currentHour <= dayOfWeek.end!) {
                    lbOpenedClosed1.text = "Aberto"
                    lbOpenedClosed1.textColor = UIColor.green
                    lbOpenedClosed2.text = "Aberto"
                    lbOpenedClosed2.textColor = UIColor.green
                } else if dayOfWeek.is_closed! {
                    lbOpenedClosed1.text = "Fechado"
                    lbOpenedClosed1.textColor = UIColor.red
                    lbOpenedClosed2.text = "Fechado"
                    lbOpenedClosed2.textColor = UIColor.red
                } else if dayOfWeek.start! == "-" && dayOfWeek.end! == "-" {
                    lbOpenedClosed1.text = "Indisponível"
                    lbOpenedClosed1.textColor = UIColor.black
                    lbOpenedClosed2.text = "Indisponível"
                    lbOpenedClosed2.textColor = UIColor.black
                } else {
                    lbOpenedClosed1.text = "Fechado"
                    lbOpenedClosed1.textColor = UIColor.red
                    lbOpenedClosed2.text = "Fechado"
                    lbOpenedClosed2.textColor = UIColor.red
                }
            }
        }
        
        
        
        if  businessDetails.contact?.whatsapp != "" {
            self.btnWhatsApp.isEnabled = true
            self.btnWhatsApp.setTitle(businessDetails.contact?.whatsapp, for: .normal)
        } 
        
        if  businessDetails.contact?.email != "" {
            self.btnEmail.isEnabled = true
            self.btnEmail.setTitle(businessDetails.contact?.email, for: .normal)
        }
        
        if  businessDetails.contact?.phone != "" {
            self.btnPhone.isEnabled = true
            self.btnPhone.setTitle(businessDetails.contact?.phone, for: .normal)
        }
        
        if  businessDetails.contact?.web != "" {
            self.btnWeb.isEnabled = true
            self.btnWeb.setTitle(businessDetails.contact?.web, for: .normal)
        }
        
        self.lbName.text = businessDetails.name
        self.cvRating.rating = businessDetails.rating!
        self.lbCategory.text = businessDetails.category
        self.lbAddress.text = getAddressFormatted()
        self.tvDescription.text = businessDetails.description
        self.pageControl.numberOfPages = 3
    
        
    }
    
    
    private func getAddressFormatted() -> String {
        
        let number = (businessDetails.address?.number)!
        let street = (businessDetails.address?.street)!
        let complement = (businessDetails.address?.complement)!
        let city = (businessDetails.address?.city)!
        let province = (businessDetails.address?.province?.uppercased())!
        let postalCode = (businessDetails.address?.postalCode?.uppercased())!
        
        return "\(number) \(street) \(complement), \(city), \(province) \(postalCode)"
    }
    
    //MARK - Set annotations on the map
    func setAnnotationsOnTheMap(){
        let businessLocation = CLLocationCoordinate2D(latitude: (businessDetails.address?.latitude)!, longitude: (businessDetails.address?.longitude)!)
        
        //Radius in Meters
        let regionRadius: CLLocationDistance = 800
        
        //Create a Map region
        let coordinateRegion = MKCoordinateRegion(center: businessLocation,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //set mapView to the region specified
        map.setRegion(coordinateRegion, animated: true)
        
        //set business location with constructor before call addAnnotation
        let businessAnnotation = BusinessAnnotation(title: "\(businessDetails.name!)", coordinate: businessLocation)
        
        self.map.addAnnotation(businessAnnotation)
    }
    
    //MARK - CollectionView methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionDetailsBusinessCell", for: indexPath) as! DetailsBusinessCollectionViewCell
        
        cell.imageCellBusiness.kf.indicatorType = .activity
        cell.imageCellBusiness.kf.setImage(
            with: URL(string: self.businessDetails.photosURL![indexPath.item]),
            placeholder: UIImage(named: Placeholders.placeholder_photo),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.item
    }
    
    
    @IBAction func btnPhone(_ sender: UIButton) {
        guard let phoneNumber = sender.titleLabel?.text else {return}
        
        let formattedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let phoneNumberURLString = "tel://\(formattedNumber)"
        if let phoneNumberURL = URL(string: phoneNumberURLString) {
            UIApplication.shared.open(phoneNumberURL, options: [:], completionHandler: nil)
        }
        else {
            self.showAlert(title: General.warning, message: CommonWarning.errorMessageInvalidPhone)
        }
    }
    
    @IBAction func btnWhatsApp(_ sender: UIButton) {
        guard let phoneNumber = sender.titleLabel?.text else {return}
        
        let formattedNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if let phoneNumberURL = URL(string: "https://api.whatsapp.com/send?phone=\(formattedNumber)") {
            UIApplication.shared.open(phoneNumberURL, options: [:], completionHandler: nil)
        }
        else {
            self.showAlert(title: General.warning, message: CommonWarning.errorMessageInvalidPhone)
        }
    }
    
    @IBAction func btnEmail(_ sender: UIButton) {
        guard let email = sender.titleLabel?.text else {return}
        
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }else{
            self.showAlert(title: General.warning, message: CommonWarning.errorEmail)
        }
    }
    
    @IBAction func btnFacebook(_ sender: UIButton) {
        guard let website = sender.titleLabel?.text else {return}
        
        if let url = URL(string: "http://\(website)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                self.showAlert(title: General.warning, message: CommonWarning.errorWebSite)
            }
        }
        
    }
    
    
    @IBAction func btnNextVersion(_ sender: Any) {
        KRProgressHUD.showMessage(General.featureUnavailable)
    }
    
    @IBAction func btnReviews(_ sender: UIButton) {
        performSegue(withIdentifier: "showReviewsVC", sender: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReviewsVC" {
            let destController = segue.destination as! ReviewsTableViewController
            destController.business = businessDetails
        }
    }
}

extension DetailsBusinessViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        return UIEdgeInsets(top: 0.0, left: (UIScreen.main.bounds.width - 330.0)/2, bottom: 0.0, right: (UIScreen.main.bounds.width - 330.0)/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return ((UIScreen.main.bounds.width - 330.0)/2)*2
    }

}
