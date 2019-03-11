//
//  MenuViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

class  MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{
    
    //IBOutlets
    @IBOutlet weak var btnSignInOut: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let imgMenu = ["home_color",
                   "settings_color"]
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let nameMenu:[String] = [NSLocalizedString(LocalizationKeys.menuHome, comment: ""),
                             NSLocalizedString(LocalizationKeys.menuSettings, comment: "")]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    // MARK: - Setup ViewController
    private func updateUI(){
        
        var accountName = LocalizationKeys.accountName
        var accountImage = UIImage(named: LocalizationKeys.imageUserDefault)
        var btnSignInOut = LocalizationKeys.buttonLogin
        var nameImageOnOff = "on"
        
        //set account name if it exists
        if appDelegate.userObj.id != nil {
            accountName = appDelegate.userObj.firstName
            accountImage = appDelegate.userObj.image
            btnSignInOut = LocalizationKeys.buttonLogout
            nameImageOnOff = "off"
        }
        
        //set constants' name
        self.btnSignInOut.setTitle(btnSignInOut, for: .normal)
        self.btnSignInOut.setImage(UIImage(named: nameImageOnOff), for: .normal)
        self.lbName.text = "\(Service.shared.getPeriodOfDay()) \(accountName)!"
        self.imgProfile.image = accountImage
        
        //image profile round
        imgProfile.layer.cornerRadius = imgProfile.bounds.height / 2
        imgProfile.layer.borderWidth = 1
        imgProfile.layer.borderColor = UIColor.black.cgColor
        imgProfile.clipsToBounds = true
    }
    
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.nameMenu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! MenuTableViewCell
        
        cell.nameMenu.text = self.nameMenu[indexPath.row]
        cell.imageMenu.image = UIImage(named:self.imgMenu[indexPath.row])
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "showHomeVC", sender: nil)
        case 1:
            performSegue(withIdentifier: "showSettingsVC", sender: nil)
        default:
            print("done")
        }
        
    }
    
    
    
    // MARK: - Account Methods
    @IBAction func btnSignInOut(_ sender: Any) {
        
        //set account name if it exists
        if appDelegate.userObj.id != nil {
            //set constants' name
            self.btnSignInOut.setTitle(LocalizationKeys.buttonLogin, for: .normal)
            self.btnSignInOut.setImage(UIImage(named: "on"), for: .normal)
            self.lbName.text = "\(Service.shared.getPeriodOfDay()) \(LocalizationKeys.accountName)!"
            self.imgProfile.image = UIImage(named: LocalizationKeys.imageUserDefault)
            self.appDelegate.userObj.resetValuesOfUserAccount()
            CoreDataService.shared.resetAllRecordsOnCoreData()
            do {
                try Auth.auth().signOut()
            } catch{}
        } else {
            performSegue(withIdentifier: "showLoginVC", sender: nil)
        }
    }
    
    
    
    
}
