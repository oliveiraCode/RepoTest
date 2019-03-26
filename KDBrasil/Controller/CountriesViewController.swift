//
//  CountriesViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-15.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class CountriesViewController:BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var list: [Countries]?
    var results: [Countries]?
    var isWithDialCode:Bool = false
    var countrySelected:Countries?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list = Service.shared.getAllCountries()
        results = list
        searchBar.becomeFirstResponder()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryTableViewCell
        
        if countrySelected?.name == self.list![indexPath.row].name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        if isWithDialCode {
            cell.lbDialCode.text = self.list![indexPath.row].dial_code
        }
        cell.imgFlag.image = UIImage(named: self.list![indexPath.row].flag ?? "unknown")
        cell.lbCountry.text = self.list![indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countrySelected = list![indexPath.row]
        tableView.reloadData()
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        appDelegate.currentCountry = countrySelected!
        CountryHandler.shared.saveCurrentCountryToCoreData()
        Service.shared.getAllStatesFromCountry()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension CountriesViewController: UISearchBarDelegate {
    
    //MARK: - Methods SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        
        self.list = self.results
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.list = self.results?.filter({ (Country) -> Bool in
            if searchText.isEmpty {return true}
            return Country.name!.lowercased().contains(searchText.lowercased())
        })
        
        self.tableView.reloadData()
    }
    
}
