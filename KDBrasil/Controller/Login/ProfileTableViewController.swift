//
//  ProfileTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-02.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProfileTableViewController: BaseTableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let sections:[String] = ["Perfil"]
    let profile:[String] = [NSLocalizedString(LocalizationKeys.accountEditProfile, comment: ""),
                            NSLocalizedString(LocalizationKeys.accountDeleteProfile, comment: "")]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.profile.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        
        cell.textLabel?.text = self.profile[indexPath.row]
        
        if indexPath.row == 1 {
            cell.textLabel?.textColor = UIColor.red
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "showEditProfileVC", sender: nil)
                break
            case 1:
                
                let alert = UIAlertController(title: LocalizationKeys.accountDeleteProfile, message: General.removeAccount, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: LocalizationKeys.buttonContinue, style: .destructive, handler: { (nil) in
                    
                    FIRFirestoreService.shared.deleteAccount()
                    
                    let alert = UIAlertController(title: "", message: "Conta deletada com sucesso.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: {(nil) in
                        self.performSegue(withIdentifier: "unwindToAccountVC", sender: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }))
                
                alert.addAction(UIAlertAction(title: LocalizationKeys.buttonCancel, style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                
                break
            default:
                print("done")
            }
        }
    }
    
}
