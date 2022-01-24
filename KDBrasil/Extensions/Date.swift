//
//  Date.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-17.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

extension Date {
    static func getFormattedDate(date: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
     
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        
        var dateOut: Date? = dateFormatterGet.date(from: date)

        //fixed bug when using v 2.0.5
        if dateOut == nil {
           dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss"
           dateOut = dateFormatterGet.date(from: date)
        }
        
        //fixed bug when using v 2.0.5
        if dateOut == nil {
            dateFormatterGet.dateFormat = "dd/MM/yyyy HH:mm:ss +zzzz"
            dateOut = dateFormatterGet.date(from: date)
        }
        
        return dateFormatterPrint.string(from: dateOut!);
    }
}
