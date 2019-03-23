//
//  Alert.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-21.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    class func showBasic(title:String, msg:String, vc:UIViewController){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}
