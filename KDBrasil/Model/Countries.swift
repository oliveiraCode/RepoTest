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
    var code:String?
    var name:String?
    var dial_code: String?
    var allStates:States?
    var flag: String?
    
    init() {
    }
    
    init(name: String, dial_code: String, code: String) {
        self.name = name
        self.code = code
        self.dial_code = dial_code
        self.flag = code
    }
    
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

class Cities:Codable {
    var city:String?
    var region:String?
    var country:String?
    var latitude:String?
    var longitude:String?
}
