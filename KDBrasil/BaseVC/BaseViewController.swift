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

    }

}




extension DetailsBusinessViewController:MFMailComposeViewControllerDelegate{
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if error == nil {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
}
