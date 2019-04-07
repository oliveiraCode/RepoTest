//
//  FilterViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-27.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
protocol FilterDelegate {
    func filtersSelected(category:String?,rating:Double?,orderBy:String?)
    func isFiltering(search:Bool)
}

class FilterViewController: BaseViewController{
    
    @IBOutlet weak var segmentedControlRating: UISegmentedControl!
    @IBOutlet weak var segmentedControlOrderBy: UISegmentedControl!
    
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnClearFilters: UIButton!
    
    var delegate: FilterDelegate?
    var categorySelected:String?
    var ratingSelected:Double?
    var orderBySelected:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    

    func updateUI(){
    
        segmentedControlRating.setSegmentStyle()
        segmentedControlOrderBy.setSegmentStyle()
        
        let cornerRadius:CGFloat = 10
        
        btnCategory.layer.cornerRadius = cornerRadius
        btnCategory.layer.borderColor = btnCategory.tintColor.cgColor
        btnCategory.layer.borderWidth = 1
        
        btnClearFilters.layer.cornerRadius = cornerRadius
        btnClearFilters.layer.borderColor = UIColor.black.cgColor
        btnClearFilters.layer.borderWidth = 1
        
        if let rating = ratingSelected {
            segmentedControlRating.selectedSegmentIndex = Int(rating-1)
        }
        
        if let category = categorySelected {
            btnCategory.setTitle(category, for: .normal)
            btnCategory.setTitleColor(UIColor.white, for: .normal)
            btnCategory.backgroundColor = btnCategory.tintColor
        }
        
        if let orderBy = orderBySelected {
            if orderBy == "A-Z" {
                segmentedControlOrderBy.selectedSegmentIndex = 1
            } else{
                segmentedControlOrderBy.selectedSegmentIndex = 0
            }
        }

    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnApply(_ sender: Any) {
        self.delegate?.isFiltering(search: true)
        self.delegate?.filtersSelected(category: categorySelected, rating: ratingSelected, orderBy: orderBySelected)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnClearFilters(_ sender: UIButton) {
        segmentedControlRating.selectedSegmentIndex = UISegmentedControl.noSegment
        segmentedControlOrderBy.selectedSegmentIndex = UISegmentedControl.noSegment
        btnCategory.setTitle("Selecionar", for: .normal)
        btnCategory.setTitleColor(btnCategory.tintColor, for: .normal)
        btnCategory.backgroundColor = UIColor.white
        categorySelected = nil
        ratingSelected = nil
        orderBySelected = nil
        delegate?.isFiltering(search: false)
    }
    
    @IBAction func segmentedControlOrderBy(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            orderBySelected = "Distancia"
            break
        default:
            orderBySelected = "A-Z"
            break
        }
        
    }
    
    @IBAction func segmentedControlRating(_ sender: UISegmentedControl) {
        ratingSelected = Double(sender.selectedSegmentIndex + 1)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategoryVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! CategoryViewController
            destController.delegate = self
        }
    }
    
}

//MARK: Category Delegate
extension FilterViewController: CategoryDelegate {
    func categoryValueSelected(categoryValue: String) {
        categorySelected = categoryValue
        btnCategory.setTitle(categorySelected, for: .normal)
        btnCategory.setTitleColor(UIColor.white, for: .normal)
        btnCategory.backgroundColor = btnCategory.tintColor
    }
}


extension UISegmentedControl {
    func setSegmentStyle() {
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        for (_, value) in self.subviews.enumerated(){
            value.layer.cornerRadius = 10
            value.layer.borderColor = self.tintColor.cgColor
            value.layer.borderWidth = 1
            value.layer.masksToBounds = true
        }
    }
    
    // create a 5x1 image with this color
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  5.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

