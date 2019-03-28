//
//  CustomAlertViewUserType.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-28.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

protocol CustomAlertViewUserTypeDelegate: class {
    func btnOKTapped(selectedOption: userType)
    func btnCancelTapped()
}

class CustomAlertViewUserType: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var segmentedControlTypeOfUser: UISegmentedControl!
    @IBOutlet weak var alertView: UIView!
    var delegate: CustomAlertViewUserTypeDelegate?
    var selectedOption:userType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        alertView.clipsToBounds = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        btnOk.addBorder(side: .Top, color: UIColor.white, width: 0.5)
        btnOk.addBorder(side: .Left, color: UIColor.white, width: 0.5)
        btnCancel.addBorder(side: .Top, color: UIColor.white, width: 0.5)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }

    @IBAction func btnCancelTapped(_ sender: Any) {
        delegate?.btnCancelTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOKTapped(_ sender: Any) {
        delegate?.btnOKTapped(selectedOption: selectedOption!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSegmentedControl(_ sender: UISegmentedControl) {
        btnOk.isEnabled = true
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedOption = userType.client
            break
        case 1:
            selectedOption = userType.professional
            break
        default:
            break
        }
    }

}
