//
//  Countries.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-08.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit


//used in search results of country
struct Countries:Codable {
    let countryCode:String?
    let countryName:String?
    var allStates:States?
}


struct States:Codable {
    var geonames:[Geonames]
}

struct Geonames:Codable{
    let name:String?
    let adminCodes1:AdminCodes?
}

struct AdminCodes:Codable{
    let ISO3166_2:String?
}

