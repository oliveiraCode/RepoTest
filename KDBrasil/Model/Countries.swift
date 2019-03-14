//
//  Countries.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-08.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

//used in search results of country
class Countries:Codable {
    var countryCode:String?
    var countryName:String?
    var allStates:States?
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


//class Cities:Codable{
//    var array:[Values]
//}

class Cities:Codable {
    var city:String?
    var region:String?
    var country:String?
    var latitude:String?
    var longitude:String?
}



//class Cities:Codable {
//    var geonames:[Geonames]?
//
//}

