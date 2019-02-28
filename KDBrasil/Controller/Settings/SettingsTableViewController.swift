//
//  SettingsTableViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2018-12-26.
//  Copyright © 2018 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAuth
import SWRevealViewController

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    //to know more https://medium.com/@mimicatcodes/create-unwind-segues-in-swift-3-8793f7d23c6f
    @IBAction func unWindToSettings(segue:UIStoryboardSegue) {}
    
    let mailComposerVC = MFMailComposeViewController()
    let sectionArray:[String] = ["Conta","Sobre","Feedback","Versão 1.0.1"]
    
    let img0:[UIImage] = [UIImage(named: "account_color")!]
    let settings0:[String] = [NSLocalizedString(LocalizationKeys.settingsAccount, comment: "")]
    
    let img1:[UIImage] = [UIImage(named: "terms_color")!,
                          UIImage(named: "privacy_color")!]
    let settings1:[String] = [NSLocalizedString(LocalizationKeys.settingsTermsOfUse, comment: ""),
                              NSLocalizedString(LocalizationKeys.settingsPrivacy, comment: "")]
    
    let img2:[UIImage] = [UIImage(named: "share_color")!,
                          UIImage(named: "contact_us_color")!]
    let settings2:[String] = [NSLocalizedString(LocalizationKeys.settingsShare, comment: ""),
                              NSLocalizedString(LocalizationKeys.settingsContactUs, comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return self.settings0.count
        case 1:
            return self.settings1.count
        case 2:
            return self.settings2.count
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsTableViewCell
        
        if indexPath.section == 0 {
            cell.lbSettings.text = self.settings0[indexPath.row]
            cell.imgSettings.image = self.img0[indexPath.row]
        }
        
        if indexPath.section == 1 {
            cell.lbSettings.text = self.settings1[indexPath.row]
            cell.imgSettings.image = self.img1[indexPath.row]
        }
        
        if indexPath.section == 2 {
            cell.lbSettings.text = self.settings2[indexPath.row]
            cell.imgSettings.image = self.img2[indexPath.row]
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                
                if (UIApplication.shared.delegate as! AppDelegate).userObj.id != nil {
                    performSegue(withIdentifier: "showProfileVC", sender: nil)
                } else {
                    self.showAlert(title: "", message: LocalizationKeys.accessProfile)
                }
                break
            default:
                print("done")
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "showTermsOfUseVC", sender: nil)
                break
            case 1:
                self.showAlert(title: "", message: General.featureUnavailable)
                break
            default:
                print("done")
            }
        }
        
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                let activityViewController = UIActivityViewController(activityItems: [ LocalizationKeys.shareApp ], applicationActivities: nil)
                
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
                
                break
            case 1:
                let subject = "App KD Brasil"
                let body = "Escreva aqui a sua mensagem."
                let email = "leandro.oliveira@live.com"
                
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients([email])
                mailComposerVC.setSubject(subject)
                mailComposerVC.setMessageBody(body, isHTML: false)
                self.present(mailComposerVC, animated: true, completion: nil)
                
                break
            default:
                print("done")
            }
        }
        
    }
    
    //MARK - SideMenu Method
    func sideMenus() {
        if revealViewController() != nil {
            
            self.btnMenu.target = revealViewController()
            self.btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 200
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
}

extension SettingsTableViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if error == nil {
            mailComposerVC.dismiss(animated: true, completion: nil)
        }
    }
    
}
