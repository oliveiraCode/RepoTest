//
//  Review.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class Review:Codable {
    var title:String?
    var description:String?
    var user_id:String?
    var user_name:String?
    var date_review:String?
    var rating:Double?
    
    
    init(title:String, description:String,user_id:String, user_name:String, date_review:String, rating:Double) {
        self.title = title
        self.description = description
        self.user_id = user_id
        self.user_name = user_name
        self.date_review = date_review
        self.rating = rating
    }
    
    init() {}
    
    var dictionary:[String:Any] {
        return [
            "title":title!,
            "description":description!,
            "user_id":user_id!,
            "user_name":user_name!,
            "date_review":date_review!,
            "rating":rating!
        ]
    }
    
    convenience init?(data: [String: Any]) {
        
        guard let title = data["title"] as? String,
            let description = data["description"] as? String,
            let user_id = data["user_id"] as? String,
            let user_name = data["user_name"] as? String,
            let date_review = data["date_review"] as? String,
            let rating = data["rating"] as? Double else {
                return nil
        }
        
        self.init(title: title, description: description, user_id: user_id, user_name: user_name, date_review: date_review, rating:rating)
    }
    
}
