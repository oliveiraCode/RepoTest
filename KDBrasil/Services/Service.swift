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

class Service {
    
    static let shared = Service()
    
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
        let distanceKm = LocationManagerService.shared.currentLocation.distance(from: adLocation)/1000
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
    
}


