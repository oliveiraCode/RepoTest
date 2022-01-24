//
//  Business.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class Business {
    var id:String?
    var description:String?
    var name:String?
    var rating:Double?
    var address:Address?
    var contact:Contact?
    var creationDate:String?
    var category:String?
    var user_id:String?
    var photosURL:[String]?
    var reviews:[Review]?
    var country:String?
    
    
    init(id:String, description:String, name:String,  rating: Double,address:Address, contact:Contact, creationDate:String, category:String, user_id:String, photosURL:[String],country:String) {
        self.id = id
        self.description = description
        self.name = name
        self.rating = rating
        self.address = address
        self.contact = contact
        self.creationDate = creationDate
        self.category = category
        self.user_id = user_id
        self.photosURL = photosURL
        self.country = country
    }
    
    init() {}
    
    
    convenience init?(data: [String: Any], addressObj:Address, contactObj:Contact) {
        
        guard let id = data["id"] as? String,
            let description = data["description"] as? String,
            let name = data["name"] as? String,
            let category = data["category"] as? String,
            let user_id = data["user_id"] as? String,
            let creationDate = data["creationDate"] as? String,
            let photosURL = data["photosURL"] as? [String],
            let country = data["country"] as? String,
            let rating = data["rating"] as? Double else {
                return nil
        }
        
        self.init(id: id, description: description, name: name, rating: rating, address: addressObj, contact: contactObj, creationDate: creationDate, category: category, user_id: user_id,photosURL: photosURL,country: country)
    }
    
}

