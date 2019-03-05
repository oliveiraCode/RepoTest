//
//  MyReviewViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos
import Firebase
import Kingfisher

class MyReviewViewController: UIViewController {
    
    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var lbNameBusiness: UILabel!
    @IBOutlet weak var ratingBusiness: CosmosView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    
    var business = Business()
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        self.imgBusiness.kf.indicatorType = .activity
        self.imgBusiness.kf.setImage(
            with: URL(string: self.business.photosURL![0]),
            placeholder: UIImage(named: Placeholders.placeholder_photo),
            options: [
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    
        //set border to TextView
        tvDescription.layer.borderWidth = 0.6
        tvDescription.layer.borderColor = UIColor.gray.cgColor
        
        self.lbNameBusiness.text = self.business.name
        self.ratingBusiness.settings.fillMode = .half
        

        
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        
        let title = tfTitle.text!
        let description = tvDescription.text!
        let user_id = appDelegate.userObj.id!
        let user_name = appDelegate.userObj.firstName!
        let date_review = Service.shared.getTodaysDate()
        let rating = ratingBusiness.rating
        
        let reviewObj = Review(title: title, description: description, user_id: user_id, user_name: user_name, date_review: date_review, rating:rating)
        
        var arrayReview:[Review]=[]
        arrayReview = business.reviews ?? []
        arrayReview.append(reviewObj)
        business.reviews = arrayReview
        
        FIRFirestoreService.shared.updateReviewData(business: business)

    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
