//
//  LocationManagerService.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManagerService: NSObject, CLLocationManagerDelegate {
    
    //MARK - properties
    static let shared = LocationManagerService()
    
    private var locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0] as CLLocation
        
        //stop to get current location to save battery
        locationManager.stopUpdatingLocation()
    }
    
    //MARK - set location manager values
    private override init() {
        super.init()
        
        //setting this view controller to be responsible of Managing the locations
        locationManager.delegate = self
        
        //set the best accurancy
        //WARNING - the best accurancy could consume too much battery
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //verifie if authorization status was setted
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
    func getDefaultCLLocationValue(){
        currentLocation = CLLocation(latitude: Coordinates.latitude, longitude: Coordinates.longitude)
    }
    
    func getAdress(completion: @escaping (_ address: String?, _ error: Error?) -> ()) {
        
        self.currentLocation = locationManager.location
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(self.currentLocation) { placemarks, error in
            if let e = error {
                completion(nil, e)
            } else {
                let placeArray = placemarks
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                guard let address = placeMark.subAdministrativeArea else {return}
                completion(address, nil)
            }
        }
    }

    
}
