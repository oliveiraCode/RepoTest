//
//  ShadowView.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-04-05.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        
        //self.backgroundColor = UIColor.clear
        
        // set the shadow of the view's layer
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
}
