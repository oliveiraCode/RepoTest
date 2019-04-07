//
//  HighlightViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-29.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Kingfisher
import MessageUI

class HighlightViewController: BaseViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewHighlight:UICollectionView!
    @IBOutlet weak var collectionViewCategory:UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var businesses = [Business]()
    var businessSelected = Business()
    
    let categories:[String] = ["Motoristas & Transfers", "Imigração", "Tradutores", "Manicure & Pedicure", "Terapeutas", "Notários", "Igrejas", "Personal Trainer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        activityIndicator.startAnimating()
        getData { (success) in
            if success {
                self.pageControl.numberOfPages = self.businesses.count
                self.collectionViewHighlight.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func getData(completionHandler: @escaping (Bool) -> Void){
        
        FIRFirestoreService.shared.readHighlightBusiness(limit: 5) { (business, error) in
            if error != nil {
                completionHandler(false)
            } else {
                self.businesses = business as! [Business]
                completionHandler(true)
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case collectionViewHighlight:
            return self.businesses.count
        default:
            return self.categories.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewHighlight {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classACell", for: indexPath) as! HighlightCollectionViewCell
            
            let image = UIImageView()
            
            image.kf.setImage(with: URL(string: self.businesses[indexPath.item].photosURL![0]),
                              placeholder: UIImage(named: Placeholders.placeholder_photo),
                              options: [.transition(.fade(1)),.cacheOriginalImage]){
                                result in
                                switch result {
                                case .success(let value):
                                    cell.imgBusiness.image = value.image.imageWithGradient(value.image)
                                case .failure(let error):
                                    print("Job failed: \(error.localizedDescription)")
                                }
            }
            
            cell.lbTitle.text = self.businesses[indexPath.item].name
            cell.lbCategory.text = self.businesses[indexPath.item].category
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            
            cell.lbTitle.text = self.categories[indexPath.item]
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.collectionViewHighlight {
            self.pageControl.currentPage = indexPath.item
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionViewHighlight {
            return CGSize(width: UIScreen.main.bounds.width, height: 300)
        } else {
            return CGSize(width: 110, height: 80)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewHighlight {
            businessSelected = self.businesses[indexPath.item]
            performSegue(withIdentifier: "showDetailsBusinessVC", sender: nil)
        }
        
        if collectionView == collectionViewCategory {
            let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
            let vc = navController.topViewController as! ListViewController
            
            vc.categorySelected = self.categories[indexPath.item]
            vc.isSearching = true
            tabBarController?.selectedIndex = 1

            vc.updateTableViewWithDataFromFirebase { (success) in
                if success {
                    vc.tableView.reloadData()
                    vc.activityIndicator.stopAnimating()
                }
            }
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailsBusinessVC" {
            let destController = segue.destination as! DetailsBusinessViewController
            destController.businessDetails = businessSelected
        }
        
        if segue.identifier == "showCategoryVC" {
            let navController = segue.destination as! UINavigationController
            let destController = navController.topViewController as! CategoryViewController
            destController.delegate = self
        }
    }
    
    @IBAction func btnAllCategories(_ sender: UIButton) {
        performSegue(withIdentifier: "showCategoryVC", sender: nil)
    }
    
    @IBAction func btnSearch(_ sender: UIButton) {
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func btnRegisterBusiness(_ sender: UIButton) {
        performSegue(withIdentifier: "showBusinessesVC", sender: nil)
    }
    
    @IBAction func btnShare(_ sender: UIButton) {
        
        let activityViewController = UIActivityViewController(activityItems: [ LocalizationKeys.shareApp ], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnTalkToUs(_ sender: UIButton) {
        
        let mailComposerVC = MFMailComposeViewController()
        
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
        
    }
    
}

extension HighlightViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if error == nil {
            controller.dismiss(animated: true, completion: nil)
        }
        
    }
}

//MARK: Category Delegate
extension HighlightViewController: CategoryDelegate {
    func categoryValueSelected(categoryValue: String) {
        let navController = self.tabBarController!.viewControllers![1] as! UINavigationController
        let vc = navController.topViewController as! ListViewController
        vc.categorySelected = categoryValue
        vc.isSearching = true
        tabBarController?.selectedIndex = 1

        vc.updateTableViewWithDataFromFirebase { (success) in
            if success {
                vc.tableView.reloadData()
                vc.activityIndicator.stopAnimating()
            }
        }
    }
}
