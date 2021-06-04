//
//  ForgotPasswordViewController.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 10/3/17.
//

import UIKit

class ForgotPasswordViewController: UIViewController, Storyboarded {
    
    // MARK: @IBOutlet
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.getColorName(.panel)
        changeNavBarTitleColor(navBar: navigationBar)
        changeNavBarShadowColor(navBar: navigationBar)
        activityIndicator.startAnimating()
        webView.delegate = self
        
        let url: NSURL!
        url = NSURL(string: "https://go.cirrent.com/forgotpassword")
        let request = NSURLRequest(url: url as URL)
        webView.loadRequest(request as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func close(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            self.navigationController?.customPop()
        }
    }
}

extension ForgotPasswordViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 1) {
            self.activityIndicator.alpha = 0
        }
    }
}
