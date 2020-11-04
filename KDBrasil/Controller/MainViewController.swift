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
        
        activityIndicator.startAnimating()
        
        checkInternet()
    }
    
    func checkInternet(){
    
        Connection.shared.internetConnectionReachability { (internetAccess) in
            if internetAccess {
                
                UpdateHandler.shared.isUpdateAvailable(completion: { (isUpdateAvailable, appID, version) in
                    if let isUpdate = isUpdateAvailable {
                        if isUpdate && !UserDefaults.standard.bool(forKey: "NotUpdate") {
                            self.showAlertIsUpdateAvailable(appID: appID!,version: version!)
                        } else {
                            self.showMainPage()
                        }
                    }
                })
                
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
                    //start once the page view controller
                    if UserDefaults.standard.bool(forKey: "Welcome") {
                        self.performSegue(withIdentifier: "showMainVC", sender: nil)
                    } else {
                        UserDefaults.standard.set(true, forKey: "Welcome")
                        
                        let viewPageController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageViewController")
                        self.present(viewPageController, animated: true, completion: nil)
                    }
                }
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    private func showAlertIsUpdateAvailable(appID:Int,version:String){
        
        let alert = UIAlertController(title: "Atualização disponível", message: "Uma nova versão do KD Brasil está disponível. \n\nDeseja atualizar agora ?", preferredStyle: .alert)
        
        

        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (_) in
            UserDefaults.standard.set(true, forKey: "NotUpdate")
            self.showMainPage()
        }))
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (_) in
            UpdateHandler.shared.launchAppStore(appID: appID)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

