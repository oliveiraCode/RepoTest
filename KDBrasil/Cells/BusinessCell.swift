//
//  BusinessCell.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-30.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos
import KRProgressHUD

class BusinessCell: UITableViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var ratingCosmosView: CosmosView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgLogo.layer.cornerRadius = 15
        self.imgLogo.clipsToBounds = true

    }
    
    @IBAction func btnNextVersion(_ sender: UIButton) {
        KRProgressHUD.showMessage(General.featureUnavailable)
    }
    
}
