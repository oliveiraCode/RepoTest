//
//  CoreDataHandler.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-01.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler {
    
    static let shared = CoreDataHandler()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - Users
    func resetAllRecordsOnCoreData() {
        let context = self.appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteRequest)
            try context.save()
        }
        catch{
            print ("There was an error")
        }
    }
    
    func readCurrentUserFromCoreData(){
        
        var cdUser : [CDUser] = []
        let context = self.appDelegate.persistentContainer.viewContext
        
        do {
            cdUser = try context.fetch(CDUser.fetchRequest())
            for valueUser in cdUser {
                self.appDelegate.userObj.id = valueUser.id
                self.appDelegate.userObj.email = valueUser.email
                self.appDelegate.userObj.firstName = valueUser.firstName
                self.appDelegate.userObj.lastName = valueUser.lastName
                self.appDelegate.userObj.phone = valueUser.phone
                self.appDelegate.userObj.password = valueUser.password
                self.appDelegate.userObj.creationDate = valueUser.creationDate
                self.appDelegate.userObj.whatsapp = valueUser.whatsapp
                self.appDelegate.userObj.favoritesIds = valueUser.favoritesIds
                self.appDelegate.userObj.isFacebook = valueUser.isFacebook
                self.appDelegate.userObj.image = UIImage(data: valueUser.image!)
            }
        } catch {
            print("Fetching User Failed")
        }
    }
    
    func saveCurrentUserToCoreData(){
        resetAllRecordsOnCoreData() //to clear all user's data on coredata
        
        let context = self.appDelegate.persistentContainer.viewContext
        
        let cdUser = CDUser(context: context)
        cdUser.creationDate = self.appDelegate.userObj.creationDate
        cdUser.id = self.appDelegate.userObj.id
        cdUser.email = self.appDelegate.userObj.email
        cdUser.firstName = self.appDelegate.userObj.firstName
        cdUser.lastName = self.appDelegate.userObj.lastName
        cdUser.phone = self.appDelegate.userObj.phone
        cdUser.password = self.appDelegate.userObj.password
        cdUser.isFacebook = self.appDelegate.userObj.isFacebook!
        
        let imageData = self.appDelegate.userObj.image.jpegData(compressionQuality: 1)
        cdUser.image = imageData
        
        cdUser.favoritesIds = self.appDelegate.userObj.favoritesIds
        
        self.appDelegate.saveContext()
    }
    
    
    //MARK: Country
    func readCurrentCountryFromCoreData(completion: @escaping(_ done:Bool)->()) {
        
        var cdCountry : [CDCountries] = []
        let context = self.appDelegate.persistentContainer.viewContext
        
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
        
        let context = self.appDelegate.persistentContainer.viewContext
        
        let cdCountry = CDCountries(context: context)
        cdCountry.code = self.appDelegate.currentCountry?.code
        cdCountry.dial_code = self.appDelegate.currentCountry?.dial_code
        cdCountry.flag = self.appDelegate.currentCountry?.flag
        cdCountry.name = self.appDelegate.currentCountry?.name
      
        self.appDelegate.saveContext()
    }
    
    func resetCountryRecordsOnCoreData() {
        let context = self.appDelegate.persistentContainer.viewContext
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
    
    
    
    
    //MARK: Settings
//    func getDefaultSettings(completion: @escaping(_ done:Bool)->()) {
//        
//        var cdSettings : [CDSettings] = []
//        let context = self.appDelegate.persistentContainer.viewContext
//        
//        do {
//            cdSettings = try context.fetch(CDSettings.fetchRequest())
//            for valueSettings in cdSettings {
//                let currentSettings = Settings()
//                currentSettings.isDarkMode = valueSettings.isDarkMode
//                completion(true)
//            }
//            
//        } catch {
//            print("Fetching Country Failed")
//        }
//    }
    
    func getDefaultSettings() -> CDSettings {
        
        var settingsList:[CDSettings] = []
        
        let context = self.appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CDSettings")
        do {
            settingsList = try context.fetch(fetchRequest) as! [CDSettings]
        }
        catch {
            print("Error during fetching favourites")
        }
        
        var settings:CDSettings? = nil
        if settingsList.count == 0 {
            settings = self.createSettingsEntity()
            do{
                try context.save()
            }
            catch{
                print ("There was an error")
            }
        }
        else {
            settings = settingsList.first
        }
        
        return settings!
        
    }
    
    private func createSettingsEntity() -> CDSettings
    {
        let context = self.appDelegate.persistentContainer.viewContext
        return CDSettings(context: context)
    }
    
}
