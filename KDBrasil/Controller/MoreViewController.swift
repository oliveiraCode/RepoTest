//
//  AccountViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let sections :[String] = ["","","","Versão \(Bundle.main.currentVersion!)"]
    var statusAccount:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    // MARK: - Setup ViewController
    private func updateUI(){
        
        var accountName = LocalizationKeys.accountName
        var accountImage = UIImage(named: LocalizationKeys.imageUserDefault)
        statusAccount = LocalizationKeys.buttonLogin
        btnEditProfile.isEnabled = false
        
        //set account name if it exists
        if appDelegate.userObj.id != nil {
            btnEditProfile.isEnabled = true
            accountName = appDelegate.userObj.firstName
            accountImage = appDelegate.userObj.image
            statusAccount = LocalizationKeys.buttonLogout
        }
        
        //set constants' name
        self.lbName.text = "\(Service.shared.getPeriodOfDay()) \(accountName)!"
        self.imgProfile.image = accountImage
        
        //image profile round
        imgProfile.layer.cornerRadius = imgProfile.bounds.height / 2
        imgProfile.clipsToBounds = true
        
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0,1,2:
            return 1
        default:
            return 0
        }
        
 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Meus anúncios"
        }
        if indexPath.section == 1 {
            cell.textLabel?.text = "Configuração"
        }
        
        if indexPath.section == 2 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.textLabel?.text = statusAccount
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            performSegue(withIdentifier: "showBusinessesVC", sender: nil)
        }
        
        if indexPath.section == 1 {
            performSegue(withIdentifier: "showSettingsVC", sender: nil)
        }
        
        if indexPath.section == 2 {
            //set account name if it exists
            if appDelegate.userObj.id != nil {
                //set constants' name
                self.btnEditProfile.isEnabled = false
                self.statusAccount = LocalizationKeys.buttonLogin
                self.lbName.text = "\(Service.shared.getPeriodOfDay()) \(LocalizationKeys.accountName)!"
                self.imgProfile.image = UIImage(named: LocalizationKeys.imageUserDefault)
                self.appDelegate.userObj.resetValuesOfUserAccount()
                UserHandler.shared.resetAllRecordsOnCoreData()
                self.tableView.reloadData()
                do {
                    try Auth.auth().signOut()
                } catch{}
            } else {
                performSegue(withIdentifier: "showLoginVC", sender: nil)
            }
        }
        
    }
    
 

}

