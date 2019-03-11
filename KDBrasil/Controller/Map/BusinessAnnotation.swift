//
//  BusinessAnnotation.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BusinessAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
