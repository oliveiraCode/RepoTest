//
//  AppDelegate.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import FirebaseCore
import FBSDKCoreKit
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var userObj = User()
    var currentCountry = Countries()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Fechar"
        
        registerPushNotification(application: application)
        FirebaseApp.configure()
        
        //set default value as a initial value
        Service.shared.getCurrentLocation()
        
//        if UserDefaults.standard.bool(forKey: "FirstTimeAfterUpdate"){
//            UserDefaults.standard.set(true, forKey: "FirstTimeAfterUpdate")
//            //try? Auth.auth().signOut()
//           // UserHandler.shared.resetAllRecordsOnCoreData()
//          //  CountryHandler.shared.resetCountryRecordsOnCoreData()
//        } else {
//            CountryHandler.shared.resetCountryRecordsOnCoreData()
//        }
        
        //get current user if it is logging
        if Auth.auth().currentUser == nil {
            UserHandler.shared.resetAllRecordsOnCoreData()
        } else {
            UserHandler.shared.readCurrentUserFromCoreData()
        }

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    

    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handle = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handle
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataHandler.shared.saveContext()
    }

    func registerPushNotification(application: UIApplication) -> () {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, err) in
            if err != nil {
                //Something bad happend
                print("Failed to get authorization for notifications: \(err?.localizedDescription ?? "default value")")
            } else {
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    
    func ConnectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        //UIApplication.shared.applicationIconBadgeNumber += 1

        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ConnectToFCM()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        ConnectToFCM()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.unknown)
        print("Successfully registered for notifications!")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
    
}
