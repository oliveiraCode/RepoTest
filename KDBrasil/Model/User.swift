//
//  User.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

enum authenticationType:String {
    case facebook = "facebook"
    case google = "google"
    case email = "email"
}


enum userType:String {
    case client = "client"
    case professional = "professional"
}


class User  {
    var id:String!
    var firstName:String!
    var lastName:String?
    var email:String!
    var password:String!
    var phone:String?
    var whatsapp:String?
    var creationDate:String?
    var favoritesIds:[String]?
    var photoURL:String?
    var image:UIImage!
    var authenticationType:authenticationType?
    var userType:userType?
    
    
    init(id:String,firstName:String, lastName:String, email:String, phone:String, whatsapp:String, creationDate:String, favoritesIds: [String], photoURL:String,authenticationType:authenticationType, userType:userType) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.whatsapp = whatsapp
        self.creationDate = creationDate
        self.favoritesIds = favoritesIds
        self.photoURL = photoURL
        self.authenticationType = authenticationType
        self.userType = userType
        
    }
    
    init() {}
    
    func resetValuesOfUserAccount() {
        self.id = nil
        self.firstName = nil
        self.lastName = nil
        self.email = nil
        self.phone = nil
        self.whatsapp = nil
        self.password = nil
        self.creationDate = nil
        self.photoURL = nil
        self.image = nil
        self.authenticationType = nil
        self.userType = nil
    }
    
    convenience init(data: [String: Any]) {
        
        let creationDate = data["creationDate"] as! String
        let id = data["id"] as! String
        let email = data["email"] as! String
        let firstName = data["firstName"] as! String
        let lastName = data["lastName"] as? String ?? ""
        let phone = data["phone"] as? String ?? "Indisponível"
        let whatsapp = data["whatsapp"] as? String ?? "Indisponível"
        let favoritesIds = data["favoritesIds"] as? [String] ?? [""]
        let photoURL = data["photoURL"] as? String ?? ""

        var authenticationType:authenticationType
        if let valueType = data["authenticationType"] as? String, valueType == "email" {
            authenticationType = .email
        } else if let valueType = data["authenticationType"] as? String, valueType == "facebook" {
            authenticationType = .facebook
        } else {
            authenticationType = .google
        }
        
        var userType:userType
        if let valueType = data["userType"] as? String, valueType == "client" {
            userType = .client
        } else {
            userType = .professional
        }

        self.init(id: id, firstName: firstName, lastName: lastName, email: email, phone: phone, whatsapp: whatsapp, creationDate: creationDate, favoritesIds: favoritesIds,photoURL: photoURL, authenticationType:authenticationType, userType:userType)
    }
    
    
}
