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

class SettingsTableViewController: BaseTableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mailComposerVC = MFMailComposeViewController()
    let sectionArray:[String] = ["País/Região","Sobre","Feedback"]
    
    let about:[String] = [NSLocalizedString(LocalizationKeys.termsOfUse, comment: ""),
                              NSLocalizedString(LocalizationKeys.privacy, comment: "")]
    
    let feedback:[String] = [NSLocalizedString(LocalizationKeys.share, comment: ""),
                              NSLocalizedString(LocalizationKeys.donate, comment: ""),
                              NSLocalizedString(LocalizationKeys.contactUs, comment: "")]
    
    var country:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateUI()
    }
    
    func updateUI(){
        country.removeAll()
        
        if let name = appDelegate.currentCountry?.name {
            country.append(name)
        } else {
            country.append("Indisponível")
        }
        
        tableView.reloadData()
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
            return self.country.count
        case 1:
            return self.about.count
        case 2:
            return self.feedback.count
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = self.country[indexPath.row]
        }
        
        if indexPath.section == 1 {
            cell.textLabel?.text = self.about[indexPath.row]
        }
        
        if indexPath.section == 2 {
            cell.textLabel?.text = self.feedback[indexPath.row]
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                performSegue(withIdentifier: "showCountryVC", sender: nil)
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
                
                self.showAlert(title: "", message: General.featureUnavailable)
                
//                guard let url = URL(string: LocalizationKeys.urlDonation) else {
//                    return //be safe
//                }
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }

                break
            case 2:
                
                let subject = "App KD Brasil"
                let body = "Escreva aqui a sua mensagem. \n\n\n\n\(Bundle.main.displayDetailsApp!)"
                let email = "leandro.oliveira@live.com"
                
                mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setToRecipients([email])
                mailComposerVC.setSubject(subject)
                mailComposerVC.setMessageBody(body, isHTML: false)
                
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposerVC, animated: true, completion: nil)
                } else {
                    self.showAlert(title: "", message: "O serviço de e-mail não está disponível.")
                }
                
                
            default:
                print("done")
            }
        }
        
    }
 
}

extension SettingsTableViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if error == nil {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
}
