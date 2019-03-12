//
//  testeViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-11.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts


class testeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtworkphone: UITextField!
    
    @IBOutlet weak var zipcode: UITextField!
    
    var cities:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Service.shared.getAllCitiesFromState(countryCode: "BR", city: "Ceara") { (cities) in
            for (_,value) in (cities?.geonames?.enumerated())!{
                self.cities.append(value.name!)
            }
            
            print(self.cities)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btn(_ sender: Any) {
        
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(zipcode.text!) {
            (placemarks, error) -> Void in
            // Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
            
            if let placemark = placemarks?[0] {
                
                print(placemark.country)
                print(placemark.subAdministrativeArea)
            }
            
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
