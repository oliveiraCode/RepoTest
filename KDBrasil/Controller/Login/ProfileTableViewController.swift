//
//  ProfileTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-02.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProfileTableViewController: UITableViewController {
    
    let img:[UIImage] = [UIImage(named: "account_color")!,
                         UIImage(named: "remove_color")!,]
    let profile:[String] = [NSLocalizedString(LocalizationKeys.accountEditProfile, comment: ""),
                            NSLocalizedString(LocalizationKeys.accountDeleteProfile, comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.profile.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        
        cell.lbSettings.text = self.profile[indexPath.row]
        cell.imgSettings.image = self.img[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            if (UIApplication.shared.delegate as! AppDelegate).userObj.isFacebook! {
                self.showAlert(title: "Conta Facebook", message: "Não é possível editar perfil de conta de Facebook.")
            } else {
                performSegue(withIdentifier: "showEditProfileVC", sender: nil)
            }
            
            break
        case 1:
            
            let alert = UIAlertController(title: LocalizationKeys.accountDeleteProfile, message: General.removeAccount, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: LocalizationKeys.buttonContinue, style: .destructive, handler: { (nil) in
                
                FIRFirestoreService.shared.deleteAccount()
                
                let alert = UIAlertController(title: "", message: "Conta deletada com sucesso.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: General.OK, style: .default, handler: {(nil) in
                    self.performSegue(withIdentifier: "unwindSegueToSettingsVC", sender: nil)
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
    
}
