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
        
        
        let businessRef = Firestore.firestore().collection(FIRCollectionReference.business)
        
        businessRef.document(business.id!).updateData(
            [
                "reviews": arrayReview.map({$0.dictionary})
            ]
        ) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved business")
            }
        }
       
        businessRef.document(business.id!).updateData(
            [
                "rating": calculateRating()
            ]
        ) { (error) in
            if error != nil {
                print("error \(error!.localizedDescription)")
            } else {
                print("data saved business")
            }
        }
        
    }
    
    func calculateRating() -> Double {
        
        var totalRating:Double = 0.0
        for value in (self.business.reviews?.enumerated())! {
            totalRating += value.element.rating!
        }
        
        return totalRating / Double((self.business.reviews?.count)!)
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
