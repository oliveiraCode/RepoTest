//
//  File.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-04-05.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

//@IBDesignable class GradientView: UIView {
//
//    private var gradientLayer: CAGradientLayer!
//
//    @IBInspectable var topColor: UIColor = .red {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var bottomColor: UIColor = .yellow {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var shadowColor: UIColor = .clear {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var shadowX: CGFloat = 0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var shadowY: CGFloat = -3 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var shadowBlur: CGFloat = 3 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var startPointX: CGFloat = 0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var startPointY: CGFloat = 0.5 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var endPointX: CGFloat = 1 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var endPointY: CGFloat = 0.5 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    override class var layerClass: AnyClass {
//        return CAGradientLayer.self
//    }
//
//    override func layoutSubviews() {
//        self.gradientLayer = self.layer as? CAGradientLayer
//        self.gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
//        self.gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
//        self.gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
//        self.layer.cornerRadius = cornerRadius
//        self.layer.shadowColor = shadowColor.cgColor
//        self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
//        self.layer.shadowRadius = shadowBlur
//        self.layer.shadowOpacity = 1
//
//    }
//
//    func animate(duration: TimeInterval, newTopColor: UIColor, newBottomColor: UIColor) {
//        let fromColors = self.gradientLayer?.colors
//        let toColors: [AnyObject] = [ newTopColor.cgColor, newBottomColor.cgColor]
//        self.gradientLayer?.colors = toColors
//        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
//        animation.fromValue = fromColors
//        animation.toValue = toColors
//        animation.duration = duration
//        animation.isRemovedOnCompletion = true
//        animation.fillMode = .forwards
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
//        self.gradientLayer?.add(animation, forKey:"animateGradient")
//    }
//}



@IBDesignable class ShadowView: UIView {
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        
    }
    
    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable var shadowSpread: CGFloat = 0 {
        didSet {
            if shadowSpread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -shadowSpread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }
    }
}
