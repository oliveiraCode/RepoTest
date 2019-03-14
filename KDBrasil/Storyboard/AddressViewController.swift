//
//  AddressViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-11.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

enum address{
    static let  State = "state"
    static let  City = "city"
    static let  Country = "country"
}

class AddressViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtworkphone: UITextField!
    
    @IBOutlet weak var zipcode: UITextField!
    
    
    
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnState: UIButton!
    @IBOutlet weak var btnCountry: UIButton!
    
 
    var addressValueSelected:String?
    var typeEntrySelected:String?
    var typeEntry:String?
    var searchFor:String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    
    func setUI(){
        btnCity.layer.borderColor = UIColor.lightGray.cgColor
        btnCity.layer.borderWidth = 0.5
        btnCity.layer.cornerRadius = 8
        btnCity.layer.masksToBounds = true
        
        btnState.layer.borderColor = UIColor.lightGray.cgColor
        btnState.layer.borderWidth = 0.5
        btnState.layer.cornerRadius = 8
        btnState.layer.masksToBounds = true
        
        btnCountry.layer.borderColor = UIColor.lightGray.cgColor
        btnCountry.layer.borderWidth = 0.5
        btnCountry.layer.cornerRadius = 8
        btnCountry.layer.masksToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnCountry.setTitle(appDelegate.currentCountry?.countryName, for: .normal)
        
        if let value = addressValueSelected, typeEntrySelected == address.City {
            self.btnCity.setTitle(value, for: .normal)
        }
        
        if let value = addressValueSelected, typeEntrySelected == address.State {
            self.btnState.setTitle(value, for: .normal)
        }
        
    }
    
    
    @IBAction func btnCountry(_ sender: UIButton) {
        typeEntry = address.Country
    }
    
    @IBAction func btnState(_ sender: UIButton) {
        typeEntry = address.State
        searchFor = appDelegate.currentCountry?.countryCode
        performSegue(withIdentifier: "showCountryStateCityVC", sender: nil)
        
    }
    
    @IBAction func btnCity(_ sender: UIButton) {
        typeEntry = address.City
        searchFor = btnState.titleLabel?.text
        performSegue(withIdentifier: "showCountryStateCityVC", sender: nil)
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCountryStateCityVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! CountryStateCityTableViewController
            destController.typeEntry = typeEntry
            destController.searchFor = searchFor
            destController.delegate = self
        }
        
    }
    
    
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //MARK:- If Delete button click
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            textField.text!.removeLast()
            return false
        }
        
        if textField == txtworkphone {
            if (textField.text?.count)! == 3 {
                textField.text = "(\(textField.text!)) "  //There we are ading () and space two things
            }
            else if (textField.text?.count)! == 9{
                textField.text = "\(textField.text!)-" //there we are ading - in textfield
            }
            else if (textField.text?.count)! > 13{
                return false
            }
        }
        return true
        
    }
    
}


//MARK:Address Delegate
extension AddressViewController: AddressDelegate {
    func getValueSelected(typeEntry: String, value: String) {
        self.addressValueSelected = value
        self.typeEntrySelected = typeEntry
    }
}
