//
//  DailyHours.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-05.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

//information for 1 day
class DailyHours:Codable{
    var is_overnight:Bool? = false
    var is_closed:Bool? = false
    var start:String? = "00:00"
    var end:String? = "00:00"
    var day:Int?
    
    init(is_overnight:Bool, is_closed:Bool, start:String, end:String, day:Int) {
        self.is_overnight = is_overnight
        self.is_closed = is_closed
        self.start = start
        self.end = end
        self.day = day
    }
    
    convenience init?(data: [String: Any]) {
   
        guard let day = data["day"] as? Int,
            let is_closed = data["is_closed"] as? Bool,
            let is_overnight = data["is_overnight"] as? Bool,
            let start = data["start"] as? String,
            let end = data["end"] as? String else {
                return nil
        }
        
        self.init(is_overnight: is_overnight, is_closed: is_closed, start: start, end: end, day: day)
    }
}
