//
//  MainViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-09.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
        NetworkManager.isReachable { _ in
            self.showMainPage()
        }
        
    }
    
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showNetworkUnavailableVC", sender: self)
        }
    }
    
    private func showMainPage() -> Void {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            Service.shared.getCurrentCountry { (done) in
                if done {
                    self.performSegue(withIdentifier: "showMainVC", sender: nil)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

    
}

