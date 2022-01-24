//
//  MyKDViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyKDViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func unwindToAccount(segue:UIStoryboardSegue) { }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let sections:[String] = ["","","Versão \(Bundle.main.currentVersion!)"]
    var settings:[String] = ["Perfil","Configuração"]
    var statusAccount:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup ViewController
    private func updateUI(){
        
        if settings.count == 3 {
            if appDelegate.userObj.userType == nil || appDelegate.userObj.userType == userType.client {
                self.settings.removeLast()
            }
        } else if appDelegate.userObj.userType == userType.professional && settings.count < 3 {
            self.settings.insert("Meus Anúncios", at: self.settings.count)
        }
        
        
        var accountName = LocalizationKeys.accountName
        var accountImage = UIImage(named: LocalizationKeys.imageUserDefault)
        statusAccount = LocalizationKeys.buttonLogin
        
        //set account name if it exists
        if appDelegate.userObj.id != nil {
            accountName = appDelegate.userObj.firstName
            accountImage = appDelegate.userObj.image
            statusAccount = LocalizationKeys.buttonLogout
        }
        
        //set constants' name
        self.lbName.text = "\(Service.shared.getPeriodOfDay()) \(accountName)!"
        self.imgProfile.image = accountImage
        
        //image profile round
        imgProfile.layer.borderWidth = 0.2
        imgProfile.layer.borderColor = UIColor.white.cgColor
        imgProfile.layer.cornerRadius = imgProfile.bounds.height / 2
        imgProfile.clipsToBounds = true
        
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return settings.count
        case 1:
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
        
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.accessoryType = .disclosureIndicator
        
        
        if indexPath.section == 0 {
            cell.textLabel?.text = self.settings[indexPath.row]
        }
        
        if indexPath.section == 1 {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.textLabel?.text = statusAccount
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                if appDelegate.userObj.id == nil {
                    showAlert(title: "", message: LocalizationKeys.accessProfile)
                } else {
                    performSegue(withIdentifier: "showEditProfileVC", sender: nil)
                }
                break
            case 1:
                performSegue(withIdentifier: "showSettingsVC", sender: nil)
                break
            case 2:
                performSegue(withIdentifier: "showBusinessesVC", sender: nil)
                break
            default:
                print("done")
            }
            
        }
        
        if indexPath.section == 1 {
            //set account name if it exists
            if appDelegate.userObj.id != nil {
                //set constants' name
                if self.settings.count == 3{
                    self.settings.removeLast()
                }
                self.statusAccount = LocalizationKeys.buttonLogin
                self.lbName.text = "\(Service.shared.getPeriodOfDay()) \(LocalizationKeys.accountName)!"
                self.imgProfile.image = UIImage(named: LocalizationKeys.imageUserDefault)
                UserHandler.shared.resetValuesOfUserAccount()
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

