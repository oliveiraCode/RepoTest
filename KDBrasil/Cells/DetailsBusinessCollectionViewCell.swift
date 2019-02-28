//
//  DetailsBusinessCollectionViewCell.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-30.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class DetailsBusinessCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCellBusiness: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //image corner with some radius
        imageCellBusiness.layer.cornerRadius = 10
        imageCellBusiness.clipsToBounds = true
        
    }
    

}
