//
//  UserHandler.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-19.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

class UserHandler {
    
    static let shared = UserHandler()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: - Users
    func resetAllRecordsOnCoreData() {
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CDUsers")
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
        
        var cdUser : [CDUsers] = []
        let context = CoreDataHandler.shared.getManagedObjectContext()

        do {
            cdUser = try context.fetch(CDUsers.fetchRequest())
            for valueUser in cdUser {
                self.appDelegate.userObj.id = valueUser.id
                self.appDelegate.userObj.email = valueUser.email
                self.appDelegate.userObj.firstName = valueUser.firstName
                self.appDelegate.userObj.lastName = valueUser.lastName
                self.appDelegate.userObj.phone = valueUser.phone
                self.appDelegate.userObj.creationDate = valueUser.creationDate
                self.appDelegate.userObj.whatsapp = valueUser.whatsapp
                self.appDelegate.userObj.photoURL = valueUser.photoURL
                self.appDelegate.userObj.favoritesIds = valueUser.favoritesIds
                self.appDelegate.userObj.image = UIImage(data: valueUser.image!)
                self.appDelegate.userObj.userType = valueUser.userType == "client" ? userType.client : userType.professional
                
                switch valueUser.authenticationType?.description {
                case "facebook" :
                    self.appDelegate.userObj.authenticationType = authenticationType.facebook
                    break
                case "google" :
                    self.appDelegate.userObj.authenticationType = authenticationType.google
                    break
                default:
                    self.appDelegate.userObj.authenticationType = authenticationType.email
                }
     
            }
        } catch {
            print("Fetching User Failed")
        }
    }
    
    
    func saveCurrentUserToCoreData(){
        resetAllRecordsOnCoreData() //to clear all user's data on coredata
        
        let context = CoreDataHandler.shared.getManagedObjectContext()
        
        let cdUser = CDUsers(context: context)
        cdUser.creationDate = self.appDelegate.userObj.creationDate
        cdUser.id = self.appDelegate.userObj.id
        cdUser.email = self.appDelegate.userObj.email
        cdUser.firstName = self.appDelegate.userObj.firstName
        cdUser.lastName = self.appDelegate.userObj.lastName
        cdUser.phone = self.appDelegate.userObj.phone
        cdUser.creationDate = self.appDelegate.userObj.creationDate
        cdUser.whatsapp = self.appDelegate.userObj.whatsapp
        cdUser.photoURL = self.appDelegate.userObj.photoURL
        cdUser.favoritesIds = self.appDelegate.userObj.favoritesIds
        
        cdUser.userType = self.appDelegate.userObj.userType?.rawValue ?? "client"
        cdUser.authenticationType = self.appDelegate.userObj.authenticationType?.rawValue ?? "email"
    
        let imageData = self.appDelegate.userObj.image.jpegData(compressionQuality: 1)
        cdUser.image = imageData
        
        do{
            try context.save()
        }
        catch{
            print ("There was an error")
        }
    }
    
}
