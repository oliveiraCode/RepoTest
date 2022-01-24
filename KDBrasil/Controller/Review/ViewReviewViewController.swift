//
//  ViewReviewViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-05.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos

class ViewReviewViewController: BaseViewController {

    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var lbNameBusiness: UILabel!
    @IBOutlet weak var ratingBusiness: CosmosView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbRatingString: UILabel!
    
    var business = Business()
    var myReview:[Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgBusiness.layer.cornerRadius = imgBusiness.bounds.height / 2
        imgBusiness.clipsToBounds = true
        imgBusiness.layer.borderWidth = 0.6
        imgBusiness.layer.borderColor = UIColor.black.cgColor
        
        self.imgBusiness.kf.indicatorType = .activity
        self.imgBusiness.kf.setImage(
            with: URL(string: self.business.photosURL![0]),
            placeholder: UIImage(named: Placeholders.placeholder_photo),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        //set border to TextView
        tvDescription.layer.borderWidth = 0.3
        tvDescription.layer.borderColor = UIColor.lightGray.cgColor
        tvDescription.delegate = self as? UITextViewDelegate
        
        self.lbNameBusiness.text = self.business.name
        self.ratingBusiness.settings.fillMode = .half
        
        self.lbRatingString.text = Service.shared.calculateRatingString(value: self.myReview[0].rating!)
        self.ratingBusiness.rating = self.myReview[0].rating!
        self.lbTitle.text = self.myReview[0].title
        self.tvDescription.text = self.myReview[0].description
        
    }



}
