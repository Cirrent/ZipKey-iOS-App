//
//  AttributionLearnMoreViewCintroller.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 10/11/17.
//

import UIKit

class AttributionLearnMoreViewCintroller: UIViewController, Storyboarded {
    
    // MARK: @IBOutlet
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var coordinator: SuccessCoordinator?
    fileprivate var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        webView.delegate = self
        
        let nsurl: NSURL!
        nsurl = NSURL(string: url!)
        let request = NSURLRequest(url: nsurl as URL)
        
        webView.loadRequest(request as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }
    
    func setProperties(url: String?) {
        self.url = url
    }
    
    @IBAction func close(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            coordinator?.dismis()
        }
    }
    
}

extension AttributionLearnMoreViewCintroller: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 1) {
            self.activityIndicator.alpha = 0
        }
    }
}
