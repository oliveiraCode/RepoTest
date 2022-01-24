//
//  Bundle.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-17.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    var currentVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var displayName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    var identifier: String? {
        return infoDictionary?["CFBundleIdentifier"] as? String
    }
    
    var displayDetailsApp:String?{
        return "iOS version: \(UIDevice.current.systemVersion) \nApp version: \(currentVersion!) (\(buildVersionNumber!))"
    }
}

