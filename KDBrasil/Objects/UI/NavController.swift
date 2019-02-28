//
//  NavController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-06.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()

        var bounds = navigationBar.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        
        gradient.colors = [UIColor.Brazil.green.cgColor, UIColor.Brazil.yellow.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)

        if let image = UIImage.imageFromLayer(gradientLayer: gradient) {
            navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        }
    }
    
}
