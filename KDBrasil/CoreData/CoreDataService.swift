//
//  CoreDataService.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-01.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //MARK - resetAllRecordsOnCoreData
    func resetAllRecordsOnCoreData() {
        let context = self.appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataConstants.CDUser)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteRequest)
            try context.save()
        }
        catch{
            print ("There was an error")
        }
    }
    
    //MARK - readCurrentUserFromCoreData
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
            print("Fetching Courses Failed")
        }
    }
    
    //MARK - saveCurrentUserToCoreData
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
    
}
