//
//  CountryTableViewCell.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-15.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbDialCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
