//
//  CategoryViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-01-08.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Firebase

protocol CategoryDelegate {
    func categoryValueSelected(categoryValue: String)  //value: string is an example of parameter
}

class CategoryViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView:UITableView!
    
    var delegate: CategoryDelegate?
    var categories:[Category]?
    var categoriesFiltered: [Category]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRFirestoreService.shared.readCategory { (category, error) in
            if error == nil {
                self.categories = category as? [Category]
                self.categoriesFiltered = self.categories
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Categorias (\(self.categories?.count ?? 0))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        
        if (self.categories?.count)! > 0 {
            cell.textLabel?.text = self.categories![indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.categoryValueSelected(categoryValue: self.categories![indexPath.row].name)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CategoryViewController: UISearchBarDelegate {
    
    //MARK: - Methods SearchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.categories = self.categoriesFiltered?.filter({ (Category) -> Bool in
            if searchText.isEmpty {return true}
            return Category.name.lowercased().contains(searchText.lowercased())
        })
        
        self.tableView.reloadData()
    }
    
}
