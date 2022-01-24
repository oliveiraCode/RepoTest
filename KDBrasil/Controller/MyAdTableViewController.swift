//
//  MyAdViewController.swift
//  BrasilNaMao
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class MyAdViewController: UITableViewController  {
    
    var categoryValue:String?
    var cell:AdNewCell = AdNewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nibName = UINib(nibName: "AdNewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AdNewCell")
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "AdNewCell", for: indexPath) as! AdNewCell
        
        if categoryValue == nil {
            cell.btnCategory.setTitle("Select", for: .normal)
        } else {
            cell.btnCategory.setTitle(self.categoryValue, for: .normal)
        }
        
        cell.btnCategory.tag = indexPath.row
        cell.btnCategory.addTarget(self, action: #selector(self.btnCategory(_:)), for: .touchUpInside);
        
        return cell
    }
    
    @objc func btnCategory(_ sender : UIButton){
        performSegue(withIdentifier: "showCategoryVC", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navController = segue.destination as! UINavigationController
        let destController = navController.topViewController as! CategoryTableViewController
        destController.delegate = self
        
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        guard let description = cell.tvDescription.text else {return}
        guard let name = cell.tfName.text else {return}
        
        guard let street = cell.tfStreet.text else {return}
        guard let city = cell.tfCity.text else {return}
        guard let province = cell.tfProvince.text else {return}
        guard let postalCode = cell.tfPostalCode.text else {return}
        
        guard let email = cell.tfEmail.text else {return}
        guard let phone = cell.tfPhone.text else {return}
        guard let web = cell.tfWeb.text else {return}
        guard let category = cell.btnCategory.title(for: .normal) else {return}
        
        
        
       CLLocationService.shared.getCoordinateFromGeoCoder(address: "\(street), \(city), \(province) \(postalCode)") { (coordinate, error) in
            
            if error == nil {
                let contact:Contact = Contact(email: email, phone: phone, web: web)
                
                let address:Address = Address(street: street, city: city, province: province, postalCode: postalCode, latitude: coordinate!.coordinate.latitude, longitude: coordinate!.coordinate.longitude)
                
                let addressObj:Ad = Ad(imageStorage: "imageStorage", description: description, name: name, address: address, contact: contact, creationDate: "01012019", category: category, user_id: "user_id")
                
                FIRFirestoreService.shared.createAd(for: addressObj, in: .ad)
                
            }
        }
    }
    
    

    
    
    
}

extension MyAdViewController: CategoryDelegate {
    func categoryValueSelected(categoryValue: String) {
        self.categoryValue = categoryValue
        self.tableView.reloadData()
    }
    
}
