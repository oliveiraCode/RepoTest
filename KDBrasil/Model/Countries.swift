//
//  Countries.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-08.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

//used in search results of country
class Countries:Codable {
    var countryCode:String?
    var countryName:String?
    var allStates:States?
    
//    required convenience init(coder aDecoder: NSCoder) {
//        let countryCode = aDecoder.decodeObject(forKey: "countryCode") as! String
//        let countryName = aDecoder.decodeObject(forKey: "countryName") as! String
//        self.init(countryCode: countryCode, countryName: countryName)
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(countryCode, forKey: "countryCode")
//        aCoder.encode(countryName, forKey: "countryName")
//    }
//    
//    init(countryCode: String, countryName: String) {
//        self.countryCode = countryCode
//        self.countryName = countryName
//    }
//    
//    init(){}
    
}




class States:Codable {
    var geonames:[Geonames]
}

class Geonames:Codable{
    let name:String?
    let adminCodes1:AdminCodes?
}

class AdminCodes:Codable{
    let ISO3166_2:String?
}

