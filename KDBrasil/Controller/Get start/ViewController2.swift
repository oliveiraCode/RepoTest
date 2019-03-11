//
//  ViewController2.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-01.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class ViewController2: BaseViewController {

    @IBOutlet weak var imagePage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePage.layer.borderColor = UIColor.black.cgColor
        imagePage.layer.borderWidth = 0.2
        imagePage.layer.cornerRadius = 25
        imagePage.layer.masksToBounds = true
    }

}
