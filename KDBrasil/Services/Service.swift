//
//  CLLocationService.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-23.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
import SWRevealViewController
import Firebase
import MapKit
import Alamofire

class Service:NSObject,CLLocationManagerDelegate{
    
    static let shared = Service()
    
    private var locationManager = CLLocationManager()
    var currentLocation:CLLocation!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getCoordinateFromGeoCoder(address:String, completionHandler: @escaping (CLLocation?, Error?) -> Void) {
        var locationCoordinate = CLLocation()
        
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if error == nil {
                locationCoordinate = (placemarks?.first?.location)!
                completionHandler(locationCoordinate, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func getTodaysDate() -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatterGet.locale = Locale(identifier: "pt_BR")
        
        return dateFormatterGet.string(from: Date())
    }
    
    
    func getPeriodOfDay() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        
        var returnString = ""
        if hour <= 11 && minute <= 59 {
            returnString = periodOfDay.goodMorging
        }
        
        if hour > 11 && hour < 18 && minute >= 00 {
            returnString =  periodOfDay.goodAfternoon
        }
        
        if hour >= 18 && hour <= 23 && minute <= 59 {
            returnString =  periodOfDay.goodEvening
        }
        
        return returnString
    }
    
    func calculateDistanceKm(lat: Double, long: Double) -> Double{
        let adLocation = CLLocation(latitude: lat, longitude: long)
        let distanceKm = currentLocation.distance(from: adLocation)/1000
        return distanceKm
    }
    
    
    func checkPermissionPhotoLibrary(completionHandler: @escaping (PHAuthorizationStatus) -> Void) {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            completionHandler(.authorized)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    completionHandler(.authorized)
                }
            })
            break
        case .denied, .restricted :
            completionHandler(.denied)
            break
        }
    }
    
    func calculateRating(reviews:[Review]) -> Double {
        
        if reviews.count > 0 {
            var totalRating:Double = 0.0
            for value in reviews.enumerated() {
                totalRating += value.element.rating!
            }
            return Double(round(10*(totalRating / Double((reviews.count))))/10)
        } else {
            return 0
        }
    }
    
    func calculateRatingString(value:Double) -> String{
        
        switch value {
        case let value where value >= 0.5 && value <= 1:
            return "Terrível"
        case let value where value >= 1.5 && value <= 2:
            return "Fraco"
        case let value where value >= 2.5 && value <= 3:
            return "Mediano"
        case let value where value >= 3.5 && value <= 4:
            return "Muito bom"
        case let value where value >= 4.5 && value <= 5:
            return "Excelente"
        default:
            return "Indisponível"
        }
    }
    
    func getAddressFromCoordinates(currentLocation:CLLocation, completion: @escaping (_ country: String?,_ isoCountryCode: String?,_ error: Error?) -> ()) {
        
        let geoCoder = CLGeocoder()
        
        let locale = Locale(identifier: "pt_BR")
        
        geoCoder.reverseGeocodeLocation(currentLocation, preferredLocale: locale) { (placemarks, error) in
            
            if let e = error {
                completion(nil,nil,e)
            } else {
                let placeArray = placemarks
                var placeMark: CLPlacemark!
                placeMark = placeArray?[0]
                guard let isoCountryCode = placeMark.isoCountryCode else {return}
                guard let country = placeMark.country else {return}
                completion(country,isoCountryCode, nil)
            }
        }
    }
    
    func saveCountryUserDefaults(){
        
        if let encoded = try? JSONEncoder().encode(appDelegate.currentCountry) {
            UserDefaults.standard.set(encoded, forKey: "country")
        }
        
    }
    
    func getCurrentCountry(completion: @escaping(_ done:Bool)->()) {
        
        if let countryData = UserDefaults.standard.data(forKey: "country"),
            let country = try? JSONDecoder().decode(Countries.self, from: countryData) {
            appDelegate.currentCountry = country
            completion(true)
        } else {
            
            // get the localized country name (in my case, it's PT Brazil)
            let ptLocale = NSLocale.init(localeIdentifier: "pt_BR")
            
            // get the current locale
            let currentLocale = Locale.current
            let countryCode = currentLocale.regionCode
         // let countryNameEN = currentLocale.localizedString(forRegionCode: countryCode!)
            
            let thePtCountryName = ptLocale.localizedString(forLocaleIdentifier: currentLocale.identifier)
            let countryNamePT = thePtCountryName.slice(from: "(", to: ")")
            
            let currentCountry = Countries()
            currentCountry.countryCode = countryCode
            currentCountry.countryName = countryNamePT
            appDelegate.currentCountry = currentCountry
            getAllStatesFromCountry()
            completion(true)
            
        }
    }
    
    
    
    func getAllStatesFromCountry(){
        guard let countryCode = self.appDelegate.currentCountry?.countryCode else {return}
        
        let url_api = "\(API_GeoNames.url_searchJSON_states+countryCode)"
        
        let sessionManager = Alamofire.SessionManager.default
        
        sessionManager.request(url_api, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).validate().responseJSON { response in
            switch(response.result) {
            case .success:
                guard let dataFromJson = response.data else {return}
                
                do {
                    let allStatesFromCountry = try JSONDecoder().decode(States.self, from: dataFromJson)
                    
                    self.appDelegate.currentCountry?.allStates = allStatesFromCountry
                    
                    let newArraySorted = allStatesFromCountry.geonames.sorted(by: { ($0.name!) < ($1.name!) })
                    
                    self.appDelegate.currentCountry?.allStates?.geonames = newArraySorted
                    self.saveCountryUserDefaults()
                    
                }catch {}
                break
            case .failure:
                print(response.result.error!)
                break
            }
        }
        
    }
    
    
    func getAllCitiesFromState(countryCode:String,city:String, completion: @escaping(_ cities:Cities?) -> ()){
        
        let url_api = "\(API_GeoNames.url_searchJSON_cities+countryCode)&q=\(city)"
        
        print(url_api)
        let sessionManager = Alamofire.SessionManager.default
        
        sessionManager.request(url_api, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).validate().responseJSON { response in
            switch(response.result) {
            case .success:
                guard let dataFromJson = response.data else {return}
                
                do {
                    let allCitiesFromState = try JSONDecoder().decode(Cities.self, from: dataFromJson)
                    
                    let newArraySorted = allCitiesFromState.geonames!.sorted(by: { ($0.name!) < ($1.name!) })
                    
                    let cities = Cities()
                    cities.geonames = newArraySorted
                    completion(cities)
                    
                }catch {}
                break
            case .failure:
                completion(nil)
                print(response.result.error!)
                break
            }
        }
        
    }
    
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
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
    func getCurrentLocation(){
        currentLocation = locationManager.location
    }
    
}

