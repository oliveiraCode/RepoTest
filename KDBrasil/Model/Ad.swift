//
//  Ad.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class Business:Codable {
    var id:String?
    var imageStorageURL:[String]?
    var description:String?
    var name:String?
    var rating:Double?
    var address:Address
    var contact:Contact
    var creationDate:String?
    var category:String?
    var user_id:String?
    
    init(description:String, name:String,  rating: Double,address:Address, contact:Contact, creationDate:String, category:String, user_id:String) {
        self.description = description
        self.name = name
        self.rating = rating
        self.address = address
        self.contact = contact
        self.creationDate = creationDate
        self.category = category
        self.user_id = user_id
    }
    
    
}
