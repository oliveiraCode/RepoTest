//
//  BaseViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-09.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import MessageUI

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Connection.shared.internetConnectionReachability { (connection) in
        //            if !connection {
        //                let alert = UIAlertController(title: "Erro ao salvar", message: "\nSem conexão com à Internet.", preferredStyle: .alert)
        //
        //                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //                self.present(alert, animated: true, completion: {
        //                    return
        //                })
        //            }
        //        }
        
        
    }
    
}

extension SettingsTableViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if error == nil {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
}

extension DetailsBusinessViewController:MFMailComposeViewControllerDelegate{
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if error == nil {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
}
