//
//  CategoryTableViewController.swift
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

class CategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var delegate: CategoryDelegate?
    var categories: [[Category]]?
    
    var sectionExpandable:Int!
    var indexPathRowSelected:Int!
    var indexPathSectionSelected:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRFirestoreService.shared.readCategory { (category, error) in
            let cat = category as! [Category]
            var dict = [Character:[Category]]()
            
            for str in cat {
                if let first = str.name.first {
                    var newCat = str
                    newCat.title = "\(first)"
                    dict[first] = (dict[first] ?? []) + [newCat]
                }
            }
            
            self.categories = dict.keys.sorted().map { dict[$0]! }
            
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        for value in (self.categories?[section].enumerated())! {
            if !value.element.opened {
                return 0
            }
        }
        return self.categories![section].count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.frame.size.height = 40
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.init(red: 236/255, green: 236/255, blue: 236/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        for value in (self.categories?[section].enumerated())! {
            button.setTitle(value.element.title, for: .normal)
        }
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        
        for row in categories![section].indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        
        var catObj: Category?
        for value in (self.categories?[section].enumerated())! {
            
            catObj = value.element
            catObj!.opened = !(catObj!.opened)
            
            self.categories?[section].remove(at: value.offset)
            self.categories?[section].insert(catObj!, at: value.offset)
            
        }
        
        if catObj!.opened {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        
        for value in (self.categories?[indexPath.section].enumerated())! {
            if value.offset == indexPath.row {
                
                if (indexPathSectionSelected == indexPath.section && indexPathRowSelected == indexPath.row ){
                    cell.accessoryType = .checkmark
                }
                else{
                    cell.accessoryType = .none
                }
                
                cell.textLabel?.text = value.element.name
                return cell
            }
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPathRowSelected = indexPath.row
        indexPathSectionSelected = indexPath.section
       
        self.btnSave.isEnabled = true
        tableView.reloadData()
    }
    
    
    @IBAction func btnSavePressed(_ sender: Any) {
        
        for value in (self.categories?[indexPathSectionSelected].enumerated())! {
            if value.offset == indexPathRowSelected {
                self.delegate?.categoryValueSelected(categoryValue: value.element.name)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
