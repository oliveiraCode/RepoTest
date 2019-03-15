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
        self.activityIndicator.startAnimating()
        checkInternet()
    }
    
    
    func checkInternet(){
        
        Connection.shared.internetConnectionReachability { (internetAccess) in
            if internetAccess {
                self.showMainPage()
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Acesso à Internet", message: "Não há nenhuma conexão com à Internet disponível. Por favor, verifique e tente novamente.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Repetir", style: .default, handler: { (_) in
                        self.checkInternet()
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    private func showMainPage() -> Void {
        DispatchQueue.main.async {
            Service.shared.getCurrentCountry { (done) in
                if done {
                    self.performSegue(withIdentifier: "showMainVC", sender: nil)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
}

