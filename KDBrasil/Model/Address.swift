//
//  Address.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import Foundation

class Address:Codable {
    var number:String?
    var street:String?
    var complement:String?
    var city:String?
    var province:String?
    var postalCode:String?
    var latitude:Double?
    var longitude:Double?
    var distance:Double?
    
    init(number:String,street:String, complement:String, city:String, province:String, postalCode:String, latitude:Double, longitude:Double) {
        self.number = number
        self.street = street
        self.complement = complement
        self.city = city
        self.province = province
        self.postalCode = postalCode
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init() {}
    
    func addressGeoCode () -> String{
        return "\(self.number!) \(self.street!), \(self.city!), \(self.province!) \(self.postalCode!)"
    }
    
    convenience init?(data: [String: Any]) {
        
        guard let number = data["number"] as? String,
            let street = data["street"] as? String,
            let complement = data["complement"] as? String,
            let city = data["city"] as? String,
            let province = data["province"] as? String,
            let postalCode = data["postalCode"] as? String,
            let latitude = data["latitude"] as? Double,
            let longitude = data["longitude"] as? Double else {
                return nil
        }
        
        self.init(number: number, street: street, complement: complement, city: city, province: province, postalCode: postalCode, latitude: latitude, longitude: longitude)

    }
    
    
    
}
