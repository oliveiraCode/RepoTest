//
//  ReviewsTableViewCell.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var cvRating: CosmosView!
    @IBOutlet weak var lbRating: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbDate_review: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cvRating.settings.fillMode = .half
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
