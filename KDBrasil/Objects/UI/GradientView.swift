//
//  GradientView.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-06.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override open class var layerClass: AnyClass {
        get{
            return CAGradientLayer.classForCoder()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        gradientLayer.colors = [UIColor.Brazil.yellow.cgColor, UIColor.Brazil.green.cgColor]
    }
    
}
