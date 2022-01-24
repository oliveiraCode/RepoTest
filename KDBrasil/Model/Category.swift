//
//  Category.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

struct Category{
    var opened = Bool()
    var title = String()
    var name: String

    init(name:String) {
        self.name = name
        self.title = "a"
        self.opened = true
    }
    
    
//    var dictionary: [String: Any] {
//        return [
//            "name": name
//        ]
//    }
}

//extension Category{
//    init?(dictionary: [String : Any], opened:Bool, title:String) {
//        guard let name = dictionary["name"] as? String else { return nil }
//
//        //self.init(opened: opened, title: title, name: name)
//    }
//}
