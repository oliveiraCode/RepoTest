//
//  Rating.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-01.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class Rating: UIView {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit(){
        
        Bundle.main.loadNibNamed("WeekHour", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        
        initUI()
    }
    
    func initUI(){
        toolBar.setGradientBackground()
    }
    
}
