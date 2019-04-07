//
//  CustomView.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-04-05.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class CustomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutView()
    }
    
    func layoutView() {
        // set the cornerRadius
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
