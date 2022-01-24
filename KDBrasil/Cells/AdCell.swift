//
//  BusinessCell.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-30.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var view: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.view.layer.cornerRadius = 10
       // self.layer.cornerRadius = 5
//        button.backgroundColor = .clear
//        button.layer.cornerRadius = 5
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
