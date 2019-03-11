//
//  BaseTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-09.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    let network = NetworkManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.reachability.whenUnreachable = { reachability in
            self.showOfflinePage()
        }
        
    }
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            
            let viewPageController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OfflineViewController")
            
            self.present(viewPageController, animated: true, completion: nil)
            
        }
    }
  
}
