//
//  UIImage Extensions.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-21.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func imageFromLayer(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
}
