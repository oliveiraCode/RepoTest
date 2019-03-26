//
//  CountryHandler.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-19.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

class CountryHandler {
    
    static let shared = CountryHandler()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: Country
    func readCurrentCountryFromCoreData(completion: @escaping(_ done:Bool)->()) {
        
        var cdCountry : [CDCountries] = []
        let context = CoreDataHandler.shared.getManagedObjectContext()
        
        do {
            cdCountry = try context.fetch(CDCountries.fetchRequest())
            for valueCountry in cdCountry {
                let currentCountry = Countries()
                currentCountry.code = valueCountry.code
                currentCountry.name = valueCountry.name
                currentCountry.dial_code = valueCountry.dial_code
                currentCountry.flag = valueCountry.flag
                self.appDelegate.currentCountry = currentCountry
                completion(true)
            }
            
        } catch {
            print("Fetching Country Failed")
        }
    }
    
    func saveCurrentCountryToCoreData(){
        resetCountryRecordsOnCoreData()
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        
        let cdCountry = CDCountries(context: context)
        cdCountry.code = self.appDelegate.currentCountry.code
        cdCountry.dial_code = self.appDelegate.currentCountry.dial_code
        cdCountry.flag = self.appDelegate.currentCountry.flag
        cdCountry.name = self.appDelegate.currentCountry.name
        
        do{
            try context.save()
        }
        catch{
            print ("There was an error")
        }
    }
    
    func resetCountryRecordsOnCoreData() {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDCountries")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteRequest)
            try context.save()
        }
        catch{
            print ("There was an error")
        }
    }
    
}
