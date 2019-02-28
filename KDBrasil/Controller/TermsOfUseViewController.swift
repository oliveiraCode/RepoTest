//
//  TermsOfUseViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-15.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController {

    @IBOutlet weak var tvTermsOfUse: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tvTermsOfUse.text = LocalizationKeys.termOfUse
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
