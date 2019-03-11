//
//  CountriesViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-10.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var imgCountrySelected: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let countries:[String] = ["Brasil","Canadá", "Estados Unidos da América"]
    let countriesCode:[String] = ["BR","CA", "US"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgCountrySelected.image =  UIImage(named: (appDelegate.currentCountry?.countryCode)!+"64")!
    }
    
    //MARK: TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Países (\(self.countries.count))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        
        if appDelegate.currentCountry?.countryName == self.countries[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = self.countries[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        imgCountrySelected.image =  UIImage(named: countriesCode[indexPath.row]+"64")!
        
        appDelegate.currentCountry?.countryCode = countriesCode[indexPath.row]
        appDelegate.currentCountry?.countryName = countries[indexPath.row]
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Service.shared.saveCountryUserDefaults()
        Service.shared.getAllStatesFromCountry()
    }
    
}
