//
//  MenuTableViewCell.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imageMenu: UIImageView!
    @IBOutlet weak var nameMenu: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
