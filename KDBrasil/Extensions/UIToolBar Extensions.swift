//
//  UIToolBar Extensions.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-21.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

extension UIToolbar {

    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.Brazil.green.cgColor, UIColor.Brazil.yellow.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        if let image = UIImage.imageFromLayer(gradientLayer: gradientLayer) {
            self.setBackgroundImage(image, forToolbarPosition: .bottom, barMetrics: .default)
        }
    }
}
