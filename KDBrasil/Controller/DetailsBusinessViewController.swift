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
import MessageUI
import CoreLocation
import KRProgressHUD

class DetailsBusinessViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource,MKMapViewDelegate {
    
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
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var businessDetails = Business()
    var isFromMyBusiness:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func editBusiness(){
        self.performSegue(withIdentifier: "showEditBusinessVC", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if businessDetails.user_id == appDelegate.userObj.id && isFromMyBusiness {
            let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editBusiness))
            self.navigationItem.rightBarButtonItem = button
        }
            
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

                self.userNameAndMember.text = "\(user!.firstName!) é membro desde \(Date.getFormattedDate(date: (user?.creationDate)!, formatter: "dd/MM/yyyy"))"
                self.userImage.image = user?.image
                
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
        
        if businessDetails.contact?.web != "" {
            self.btnWeb.isEnabled = true
            self.btnWeb.setTitle(Service.shared.checkIfContainSociaMediaOrWebsite(string: businessDetails.contact!.web!), for: .normal)
        }
        
        self.lbName.text = businessDetails.name
        self.cvRating.rating = businessDetails.rating!
        self.lbCategory.text = businessDetails.category
        self.lbAddress.text = getAddressFormatted()
        self.tvDescription.text = businessDetails.description
        self.pageControl.numberOfPages = self.businessDetails.photosURL?.count ?? 0
    
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
        return self.businessDetails.photosURL?.count ?? 0
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
        
        let mailComposerVC = MFMailComposeViewController()
        let subject = businessDetails.name!
        let body = "Escreva aqui a sua mensagem."
        
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showAlert(title: "", message: "O serviço de e-mail não está disponível.")
        }
        
    }
    
    @IBAction func btnFacebook(_ sender: UIButton) {
        performSegue(withIdentifier: "showWebVC", sender: nil)
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
        
        if segue.identifier == "showEditBusinessVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! MyBusinessViewController
            destController.businessDetails = businessDetails
            destController.isNewBusiness = false
        }
        
        if segue.identifier == "showWebVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! WebViewController
            
            if let url = businessDetails.contact?.web {
                destController.title = Service.shared.checkIfContainSociaMediaOrWebsite(string: url)
                destController.urlSelected = url
            }
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
