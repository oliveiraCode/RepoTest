//
//  CategoryCollectionViewCell.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-04-03.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // set the cornerRadius
        view.layer.cornerRadius = 10
    }
    
}
