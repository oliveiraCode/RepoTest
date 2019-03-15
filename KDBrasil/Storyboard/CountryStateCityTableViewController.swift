//
//  StatesTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-11.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

protocol AddressDelegate {
    func getValueSelected(typeEntry:String, value:String)
}

class StatesTableViewController: UITableViewController {
    
    var cities:[Cities] = []
    var states:[Geonames] = []
    
    var delegate:AddressDelegate?
    var typeEntry:String?
    var searchFor:String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func checkTypeOfSearch(){
        
        switch typeEntry {
            
        case address.City:
            
            self.title = "Cidades"

            Service.shared.getAllCitiesFromState(countryCode: (appDelegate.currentCountry?.countryCode)!, city: searchFor!) { (citiesResult) in
                
                if citiesResult != nil {
                    self.cities = citiesResult!
                    self.tableView.reloadData()
                }
            }
            
            break
        case address.State:
            self.title = "Estados"
            states = (appDelegate.currentCountry?.allStates?.geonames)!
            self.tableView.reloadData()
            break
        default:
            
            break
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkTypeOfSearch()
        
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch typeEntry {
        case address.City:
            return self.cities.count
        case address.State:
            return self.states.count
        default:
            return 0
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesCell", for: indexPath)
        
        if typeEntry == address.City {
            cell.textLabel?.text = self.cities[indexPath.row].city
        } else if typeEntry == address.State {
            cell.textLabel?.text = self.states[indexPath.row].name
        } else {
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if typeEntry == address.State {
            self.delegate?.getValueSelected(typeEntry: typeEntry!, value: self.states[indexPath.row].name!)
        }
        
        if typeEntry == address.City {
            self.delegate?.getValueSelected(typeEntry: typeEntry!, value: self.cities[indexPath.row].city!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
