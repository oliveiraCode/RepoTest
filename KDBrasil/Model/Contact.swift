//
//  Contact.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import Foundation

class Contact:Codable {
    var email:String?
    var phone:String?
    var whatsapp:String?
    var web:String?
    
    init(email:String, phone:String,whatsapp:String, web:String) {
        self.email = email
        self.phone = phone
        self.whatsapp = whatsapp
        self.web = web
    }
    
    init() {}
    
    
    convenience init?(data: [String: Any]) {
        
        guard let email = data["email"] as? String,
            let phone = data["phone"] as? String,
            let whatsapp = data["whatsapp"] as? String,
            let web = data["web"] as? String else {
                return nil
        }
        
        self.init(email: email, phone: phone, whatsapp: whatsapp, web: web)
    }
    
}
