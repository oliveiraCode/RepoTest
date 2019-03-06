//
//  DonateViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-05.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import WebKit

class DonateViewController: UIViewController, WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.paypal.me/lfo")
        let request = URLRequest(url: url!)
        
        activityIndicator.startAnimating()
        webView.load(request)
        webView.navigationDelegate = self


    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    


}
