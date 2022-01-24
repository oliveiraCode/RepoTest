//
//  Connection.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-09.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//
import Foundation
import Reachability

class Connection: NSObject {

    let reachability = try? Reachability()
    
    static let shared = Connection()

    override init() {
        super.init()
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func internetConnectionReachability(completed: @escaping (Bool) -> Void){
        //Check connection
        switch(reachability?.connection) {
        case .cellular, .wifi:
            completed(true)
        case .some(.none), .none:
            completed(false)
        case .unavailable:
            completed(false)
        }
    }
    
   private func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            print("Error starting notifier")
            return
        }
    }
    
}

