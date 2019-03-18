//
//  Bundle.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-17.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var displayName: String? {
        return infoDictionary?["CFBundleDisplayName"] as? String
    }
    
    var displayDetailsApp:String?{
        return "Name: \(displayName!) \nRelease: \(releaseVersionNumber!) \nBuild: \(buildVersionNumber!)"
    }
}
