//
//  UpdateHandler.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-21.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation
import Alamofire

class UpdateHandler {
    
    static let shared = UpdateHandler()
    
    func isUpdateAvailable(completion: @escaping(_ isAvailable:Bool?,_ trackId:Int?,_ version:String?)->()) {
        
        guard let bundleID = Bundle.main.bundleIdentifier,
            let currentVersion = Bundle.main.currentVersion,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)") else {return}
        
        Alamofire.request(url).responseJSON { response in
            
            if let JSON = response.result.value, let json = JSON as? [String: Any]  {
                if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String, let trackId = result["trackId"] as? Int {
                    completion(version != currentVersion, trackId, version)
                }
            }else {
                completion(nil,nil,nil)
            }
        }
    }
    
    
    func launchAppStore(appID:Int) {
        guard let url = URL(string: "https://itunes.apple.com/app/id\(appID)") else {return}
        
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    
}
