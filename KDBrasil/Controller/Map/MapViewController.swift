//
//  MapViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-09.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SWRevealViewController

class MapViewController: BaseViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    @IBOutlet weak var viewLocationDenied: UIView!
    @IBOutlet weak var btnOpeniOSSettings:UIButton!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationManager = CLLocationManager()
    var myCurrentLocation = CLLocation()
    var businesses = [Business]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        
        btnOpeniOSSettings.layer.borderColor = UIColor.black.cgColor
        btnOpeniOSSettings.layer.borderWidth = 0.5
        btnOpeniOSSettings.layer.cornerRadius = 20
        btnOpeniOSSettings.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callLocationServices()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myCurrentLocation = locations[0] as CLLocation
        
        //Radius in Meters
        let regionRadius: CLLocationDistance = 20000
        
        //Define Region
        let coordinateRegion: MKCoordinateRegion!
        
        //Create a Map region
        coordinateRegion = MKCoordinateRegion(center: myCurrentLocation.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        
        //set mapView to the region specified
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation() //para a atualizacao da localizacao atual
        
        //Displaying all Stores Pins (annotations)
        displayAnnotations()
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        mapView.selectAnnotation(annotation!, animated: true)
    }
    
    func callLocationServices(){
        //setting this view controller to be responsible of Managing the locations
        locationManager.delegate = self
        
        //we want the best accurancy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .denied {
            self.view.bringSubviewToFront(viewLocationDenied)
        } else {
            self.view.sendSubviewToBack(viewLocationDenied)
        }
        
        //getting the current location
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func btnOpeniOSSettings(_ sender: UIButton) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {return}
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }
    }
    
    func displayAnnotations(){
        for (_,businessItem) in businesses.enumerated() {
            let businessObj : Business = businessItem
            let BusinessLocation = CLLocationCoordinate2D(latitude: (businessObj.address?.latitude)!, longitude: (businessObj.address?.longitude)!)
            let aTitle = "\(businessObj.name!)"
            let aSubtitle =  "\(businessObj.category!)"
            
            let businessAnnotation = BusinessAnnotation(title: aTitle, subtitle: aSubtitle, coordinate: BusinessLocation)
            
            mapView.addAnnotation(businessAnnotation)
            mapView.selectAnnotation(businessAnnotation, animated: true)
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - SideMenu Method
    func sideMenus() {
        if revealViewController() != nil {
            
            self.btnMenu.target = revealViewController()
            self.btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        changeTitleNavigatorBar()
    }
    
    
    func changeTitleNavigatorBar(){
        let logo = UIImage(named: "logo_navbar")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
}





