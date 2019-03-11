//
//  OfflineViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-09.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class OfflineViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.reachability.whenReachable = { reachability in
            self.showOnlinePage()
        }
        
    }
    
    private func showOnlinePage() -> Void {
        DispatchQueue.main.async {
            Service.shared.getCurrentCountry { (done) in
                if done {
                    
                    self.performSegue(withIdentifier: "showStartVC", sender: nil)
  
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}
