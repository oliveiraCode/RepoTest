//
//  MyReviewViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-04.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class MyReviewViewController: UIViewController {
    
    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var lbNameBusiness: UILabel!
    @IBOutlet weak var ratingBusiness: CosmosView!
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbRatingString: UILabel!
    
    var business = Business()
    var myReview:[Review] = []
    
    //Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Minha Avaliação"
        self.hideKeyboardWhenTappedAround()
        
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
        
        updateUI()
        
        ratingBusiness.didTouchCosmos = {ratingBusiness in
            self.lbRatingString.text = Service.shared.calculateRatingString(value: ratingBusiness)
        }
    }
    
    
    func updateUI(){
        if myReview.count > 0 {
            self.ratingBusiness.rating = self.myReview[0].rating!
            self.tfTitle.text = self.myReview[0].title
            self.tvDescription.text = self.myReview[0].description
        }
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
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
